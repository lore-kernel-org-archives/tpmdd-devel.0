From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: add buffer access validation in
 tpm2_get_pcr_allocation()
Date: Mon, 30 Jan 2017 23:47:24 +0200
Message-ID: <20170130214724.2kbkmk65h7zjrbcm@intel.com>
References: <1485530749-22948-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20170129144037.sdqd4vutt73isz2i@intel.com>
 <588E23EF.2050202@linux.vnet.ibm.com>
 <20170129212020.xz3s4unx5lhxxrgs@intel.com>
 <588EABD6.1040500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <588EABD6.1040500@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 30, 2017 at 08:28:30AM +0530, Nayna wrote:
> 
> 
> On 01/30/2017 02:50 AM, Jarkko Sakkinen wrote:
> > On Sun, Jan 29, 2017 at 10:48:39PM +0530, Nayna wrote:
> > > 
> > > 
> > > On 01/29/2017 08:10 PM, Jarkko Sakkinen wrote:
> > > > On Fri, Jan 27, 2017 at 10:25:49AM -0500, Nayna Jain wrote:
> > > > > This patch add validation in tpm2_get_pcr_allocation to avoid
> > > > > access beyond response buffer length.
> > > > > 
> > > > > Suggested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > > 
> > > > This validation looks broken to me.
> > > > 
> > > > > ---
> > > > >    drivers/char/tpm/tpm2-cmd.c | 28 +++++++++++++++++++++++-----
> > > > >    1 file changed, 23 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > > > > index 4aad84c..02c1ea7 100644
> > > > > --- a/drivers/char/tpm/tpm2-cmd.c
> > > > > +++ b/drivers/char/tpm/tpm2-cmd.c
> > > > > @@ -1008,9 +1008,13 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
> > > > >    	struct tpm2_pcr_selection pcr_selection;
> > > > >    	struct tpm_buf buf;
> > > > >    	void *marker;
> > > > > -	unsigned int count = 0;
> > > > > +	void *end;
> > > > > +	void *pcr_select_offset;
> > > > > +	unsigned int count;
> > > > > +	u32 sizeof_pcr_selection;
> > > > > +	u32 resp_len;
> > > > 
> > > > Very cosmetic but we almos almost universally use the acronym 'rsp' in
> > > > the TPM driver.
> > > 
> > > Sure will update.
> > > 
> > > > 
> > > > >    	int rc;
> > > > > -	int i;
> > > > > +	int i = 0;
> > > > 
> > > > Why do you need to initialize it?
> > > 
> > > Because in out: count is replaced with i.
> > > And it is replaced because  now for loop can break even before reaching
> > > count, because of new buffer checks.
> > > > 
> > > > > 
> > > > >    	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
> > > > >    	if (rc)
> > > > > @@ -1034,15 +1038,29 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
> > > > >    	}
> > > > > 
> > > > >    	marker = &buf.data[TPM_HEADER_SIZE + 9];
> > > > > +
> > > > > +	resp_len = be32_to_cpup((__be32 *)&buf.data[2]);
> > > > > +	end = &buf.data[resp_len];
> > > > 
> > > > What if the response contains larger length than the buffer size?
> > > 
> > > Isn't this check need to be done in tpm_transmit_cmd for all responses ?
> > > Though, it seems it is not done there as well.
> > > 
> > > And to understand what do we expect max buffer length. PAGE_SIZE or
> > > TPM_BUFSIZE ?
> > 
> > Oops. You are correct it is done there:
> > 
> > if (len != be32_to_cpu(header->length))
> > 	return -EFAULT;
> > 
> > So need to do this.
> 
> To be sure, means nothing need to be done in this. Right ?

This is correct.

> And guess this was the only thing you meant by broken for this patch.
> 
> I will do other two smaller changes as I send the whole new patchset.
> 
> Thanks & Regards,
>   - Nayna

/Jarkko
