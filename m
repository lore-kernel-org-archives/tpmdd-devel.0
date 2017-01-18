From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6] tpm: Check size of response before accessing data
Date: Wed, 18 Jan 2017 15:36:46 +0200
Message-ID: <20170118133646.uvbkt7d4blv2pdbn@intel.com>
References: <1484602871-20145-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170117144905.4haeudj3v5ycohr3@intel.com>
 <bc4ff967-1a5f-8e3e-c26e-07a13460a3a8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bc4ff967-1a5f-8e3e-c26e-07a13460a3a8@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 17, 2017 at 05:27:47PM -0500, Stefan Berger wrote:
> On 01/17/2017 09:49 AM, Jarkko Sakkinen wrote:
> > On Mon, Jan 16, 2017 at 04:41:11PM -0500, Stefan Berger wrote:
> > 
> > > + * @min_rx_length: minimum expected length of response
> > Please, rename as min_rsp_body_len and change the description
> > accordingly.
> > 
> > >    * @flags: tpm transmit flags - bitmap
> > >    * @desc: command description used in the error message
> > >    *
> > > @@ -434,25 +435,34 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
> > >    *     A positive number for a TPM error.
> > >    */
> > >   ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
> > > -			 int len, unsigned int flags, const char *desc)
> > > +			 size_t cmd_length, size_t min_rx_length,
> > > +			 unsigned int flags, const char *desc)
> > >   {
> > >   	const struct tpm_output_header *header;
> > >   	int err;
> > > +	ssize_t len;
> > > -	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> > > +	len = tpm_transmit(chip, (const u8 *)cmd, cmd_length, flags);
> > >   	if (len <  0)
> > >   		return len;
> > >   	else if (len < TPM_HEADER_SIZE)
> > >   		return -EFAULT;
> > >   	header = cmd;
> > > +	if (len < be32_to_cpu(header->length))
> > > +		return -EFAULT;
> > >   	err = be32_to_cpu(header->return_code);
> > >   	if (err != 0 && desc)
> > >   		dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
> > >   			desc);
> > > +	if (err)
> > > +		return err;
> > > -	return err;
> > > +	if (be32_to_cpu(header->length) < min_rx_length)
> > > +		return -EFAULT;
> > > +
> > > +	return 0;
> > >   }
> > >   #define TPM_DIGEST_SIZE 20
> > > @@ -468,7 +478,7 @@ static const struct tpm_input_header tpm_getcap_header = {
> > >   };
> > >   ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> > > -		   const char *desc)
> > > +		   const char *desc, size_t min_cap_length)
> > tpm_getcap update should be its own commit.
> 
> tpm_getcap needs to pass something as min_rsp_body_length to
> tpm_transmit_cmd. What would it pass?

I do not understand the problem. You are already

  TPM_HEADER_SIZE + min_cap_length

/Jarkko
