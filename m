From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v7] tpm: Check size of response before
	accessing data
Date: Fri, 20 Jan 2017 19:55:22 +0200
Message-ID: <20170120175522.zsotpu22be3nozbl@intel.com>
References: <1484828352-23202-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170120133630.ld5shdqhquxzd7sn@intel.com>
	<20170120162145.lrdcrf5iw6d6otd3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120162145.lrdcrf5iw6d6otd3-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 20, 2017 at 06:21:58PM +0200, Jarkko Sakkinen wrote:
> On Fri, Jan 20, 2017 at 03:36:30PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 19, 2017 at 07:19:12AM -0500, Stefan Berger wrote:
> > > Make sure that we have not received less bytes than what is indicated
> > > in the header of the TPM response. Also, check the number of bytes in
> > > the response before accessing its data.
> > > 
> > > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Oops. I found some odd stuff after all so hold on for a moment.
> I could do these updates myself probably...
> 
> > >  ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
> > > -			 int len, unsigned int flags, const char *desc)
> > > +			 size_t len, size_t min_rsp_body_length,
> > > +			 unsigned int flags, const char *desc)
> 
> BTW, maybe the cmd_length would be actually a better idea because
> it gets mixes witht local variable.
> 
> > >  {
> > >  	const struct tpm_output_header *header;
> > >  	int err;
> > > +	ssize_t length;
> 
> Maybe it would make sense to name this as rsp_length.
> 
> > >  
> > > -	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> > > -	if (len <  0)
> > > -		return len;
> > > -	else if (len < TPM_HEADER_SIZE)
> > > +	length = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> > > +	if (length <  0)
> > > +		return length;
> > > +	else if (length < TPM_HEADER_SIZE)
> > >  		return -EFAULT;
> > >  
> > >  	header = cmd;
> > > +	if (length < be32_to_cpu(header->length))
> > > +		return -EFAULT;
> 
> Why '<' and not '!='? In what legit case length would be larger?
> 
> > >  
> > >  	err = be32_to_cpu(header->return_code);
> > >  	if (err != 0 && desc)
> > >  		dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
> > >  			desc);
> > > +	if (err)
> > > +		return err;
> > >  
> > > -	return err;
> > > +	if (be32_to_cpu(header->length) <
> > > +	    min_rsp_body_length + TPM_HEADER_SIZE)
> > > +		return -EFAULT;
> 
> Why couldn't you use 'length' here?
> 
> /Jarkko

Anyway,

Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
