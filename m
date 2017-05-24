From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 2/2] tpm: vtpm_proxy: Implement request_locality
 function.
Date: Wed, 24 May 2017 12:25:24 -0700
Message-ID: <20170524192524.vtahahrw3kh62f3x@intel.com>
References: <1494460462-29022-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1494460462-29022-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170515124159.2o3ybbxep6vldmid@intel.com>
 <17af34d3-e07e-8865-0026-ec3e4994a7aa@linux.vnet.ibm.com>
 <20170520124757.qdlkuv42kpm2dsj3@intel.com>
 <76ca7109-235b-9e22-4cf1-edda48a2921c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <76ca7109-235b-9e22-4cf1-edda48a2921c@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, May 21, 2017 at 07:52:32PM -0400, Stefan Berger wrote:
> On 05/20/2017 08:47 AM, Jarkko Sakkinen wrote:
> > On Mon, May 15, 2017 at 11:56:51AM -0400, Stefan Berger wrote:
> > > On 05/15/2017 08:41 AM, Jarkko Sakkinen wrote:
> > > > On Wed, May 10, 2017 at 07:54:22PM -0400, Stefan Berger wrote:
> > > > > Implement the request_locality function. To set the locality on the
> > > > > backend we define vendor-specific TPM 1.2 and TPM 2 ordinals and send
> > > > > a command to the backend to set the locality for the next commands.
> > > > > 
> > > > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > > > ---
> > > > >    drivers/char/tpm/tpm.h            |  1 +
> > > > >    drivers/char/tpm/tpm_vtpm_proxy.c | 34 ++++++++++++++++++++++++++++++++++
> > > > >    include/uapi/linux/vtpm_proxy.h   |  5 +++++
> > > > >    3 files changed, 40 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > > > index 4b4c8de..10f0467 100644
> > > > > --- a/drivers/char/tpm/tpm.h
> > > > > +++ b/drivers/char/tpm/tpm.h
> > > > > @@ -527,6 +527,7 @@ enum tpm_transmit_flags {
> > > > >    	TPM_TRANSMIT_UNLOCKED	= BIT(0),
> > > > >    };
> > > > > +ssize_t tpm_transfer(struct tpm_chip *chip, u8 *buf, u32 count, size_t bufsiz);
> > > > >    ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> > > > >    		     u8 *buf, size_t bufsiz, unsigned int flags);
> > > > >    ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> > > > > diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > > > index 751059d..374c4ff 100644
> > > > > --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> > > > > +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > > > @@ -371,6 +371,39 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
> > > > >    	return ret;
> > > > >    }
> > > > > +static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
> > > > > +{
> > > > > +	struct tpm_buf buf;
> > > > > +	int rc;
> > > > > +	const struct tpm_output_header *header;
> > > > > +
> > > > > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > > > > +		rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
> > > > > +				  TPM2_CC_SET_LOCALITY);
> > > > > +	else
> > > > > +		rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND,
> > > > > +				  TPM_ORD_SET_LOCALITY);
> > > > > +	if (rc)
> > > > > +		return rc;
> > > > > +	tpm_buf_append_u8(&buf, locality);
> > > > > +
> > > > > +	rc = tpm_transfer(chip, buf.data, tpm_buf_length(&buf), PAGE_SIZE);
> > > > > +	if (rc < 0) {
> > > > > +		locality = rc;
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	header = (const struct tpm_output_header *)buf.data;
> > > > > +	rc = be32_to_cpu(header->return_code);
> > > > > +	if (rc)
> > > > > +		locality = -1;
> > > > > +
> > > > > +out:
> > > > > +	tpm_buf_destroy(&buf);
> > > > > +
> > > > > +	return locality;
> > > > > +}
> > > > > +
> > > > >    static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
> > > > >    	.flags = TPM_OPS_AUTO_STARTUP,
> > > > >    	.recv = vtpm_proxy_tpm_op_recv,
> > > > > @@ -380,6 +413,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
> > > > >    	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
> > > > >    	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
> > > > >    	.req_canceled = vtpm_proxy_tpm_req_canceled,
> > > > > +	.request_locality = vtpm_proxy_request_locality,
> > > > >    };
> > > > >    /*
> > > > > diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
> > > > > index a69e991..6b91c2c 100644
> > > > > --- a/include/uapi/linux/vtpm_proxy.h
> > > > > +++ b/include/uapi/linux/vtpm_proxy.h
> > > > > @@ -46,4 +46,9 @@ struct vtpm_proxy_new_dev {
> > > > >    #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
> > > > > +/* vendor specific commands to set locality */
> > > > > +#define TPM2_CC_SET_LOCALITY	0x20001000
> > > > > +#define TPM_ORD_SET_LOCALITY	0x20001000
> > > > > +
> > > > > +
> > > > >    #endif /* _UAPI_LINUX_VTPM_PROXY_H */
> > > > > -- 
> > > > > 2.4.3
> > > > This is a question.
> > > > 
> > > > Did you have some kind of big idea with 0x20? I was just thinking
> > > > that one way to do this would to allocate starting from 0xFFFFFFFF.
> > > Not quite. Per TPM 1.2 and TPM 2 specs we should operate here with Vendor
> > > specific commands and they are identified by bit 29.
> > > 
> > > Check section 17 'Ordinals': https://trustedcomputinggroup.org/wp-content/uploads/TPM-Main-Part-2-TPM-Structures_v1.2_rev116_01032011.pdf
> > > 
> > > Check section 8.9 TPMA_CC: https://trustedcomputinggroup.org/wp-content/uploads/TPM-Rev-2.0-Part-2-Structures-01.38.pdf
> > > 
> > > If anything was the 'big idea' then it was the offset '0x1000' :-)
> > > 
> > >     Stefan
> > Maybe we should use have concept of driver specific commands? You could
> > in theory use vtpm to proxy a real chip and this would cause a potential
> > regression as vendor specific code might collide.
> 
> As long as the recipient knows where the command is coming from, it can
> interpret it and convert it to whatever the target understands. In this case
> it would only need to know that these commands are coming from the Linux
> vTPM proxy device driver with the meaning of setting the locality.
> 
> I think the danger of collision is low and anything like driver specific
> commands seems like it would have to become a standard within TCG where they
> would allocate a range for those types of commands. I'd rather not go down
> that road.
> 
>    Stefan

I think this makes sense.

Reviewed-by: Jarkko Sakkinen <jarko.sakkinen@linux.intel.com>

/Jarkko
