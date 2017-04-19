From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/3] tpm: vtpm_proxy: Implement request_locality
Date: Wed, 19 Apr 2017 18:35:21 +0300
Message-ID: <20170419153521.t4lrf76snh5n6tgy@intel.com>
References: <1492442371-30252-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1492442371-30252-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170418164748.GB7181@obsidianresearch.com>
 <4df6f613-7276-7a3a-4e3d-07657f815030@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4df6f613-7276-7a3a-4e3d-07657f815030@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 18, 2017 at 06:41:28PM -0400, Stefan Berger wrote:
> On 04/18/2017 12:47 PM, Jason Gunthorpe wrote:
> > On Mon, Apr 17, 2017 at 11:19:30AM -0400, Stefan Berger wrote:
> > > Implement the request_locality function. Accept all localties assuming
> > > that the emulator handling the localities will check for a valid locality.
> > > 
> > > Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > >   drivers/char/tpm/tpm_vtpm_proxy.c | 6 ++++++
> > >   1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > index be0a268..bf59426 100644
> > > +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> > > @@ -371,6 +371,11 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
> > >   	return ret;
> > >   }
> > > +static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
> > > +{
> > > +	return locality;
> > > +}
> > I thought we had agreed to make this function pass/fail?
> 
> 
> What do you mean? The TIS driver for example returns the locality if
> accepted, a negative error code otherwise. In the case of the vtpm proxy I
> would let the emulator handle the locality on the level of TPM error codes
> (TPM_BAD_LOCALITY for TPM1.2 or TPM_RC_LOCALITY for TPM 2).
> 
>   Stefan

Jason,

I tried to make "lowest common denominator" change for 4.12 just to
get work started and issue in tpm_crb sorted out. We can revisit this
for 4.13.

/Jarkko
