From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH 2/2] tpm/tpm2-chip: fix kdoc errors
Date: Mon, 14 Nov 2016 13:05:41 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B5431BEFA@hasmsx108.ger.corp.intel.com>
References: <1477962314-26763-1-git-send-email-tomas.winkler@intel.com>
 <1477962314-26763-3-git-send-email-tomas.winkler@intel.com>
 <20161104042559.b2pp3sn4xdy7yvuc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161104042559.b2pp3sn4xdy7yvuc@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

.org
> Subject: Re: [PATCH 2/2] tpm/tpm2-chip: fix kdoc errors
> 
> On Tue, Nov 01, 2016 at 03:05:14AM +0200, Tomas Winkler wrote:
> > Use correct kdoc format, describe correct parameters and return values.
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >  drivers/char/tpm/tpm2-cmd.c | 107
> > +++++++++++++++++++++++++++-----------------
> >  1 file changed, 66 insertions(+), 41 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index 7df55d58c939..a7a519c87bee 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -258,11 +258,13 @@ static const struct tpm_input_header
> tpm2_pcrread_header = {
> >   * tpm2_pcr_read() - read a PCR value
> >   * @chip:	TPM chip to use.
> >   * @pcr_idx:	index of the PCR to read.
> > - * @ref_buf:	buffer to store the resulting hash,
> > + * @res_buf:	buffer to store the resulting hash,
> >   *
> > - * 0 is returned when the operation is successful. If a negative
> > number is
> > - * returned it remarks a POSIX error code. If a positive number is
> > returned
> > - * it remarks a TPM error.
> > + *
> > + * Return:
> > + *     0 when the operation is successful
> > + *     A negative number for system errors (errno)
> > + *     A positive number for a TPM error.
> >   */
> >  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)  {
> > @@ -304,13 +306,15 @@ static const struct tpm_input_header
> > tpm2_pcrextend_header = {
> >
> >  /**
> >   * tpm2_pcr_extend() - extend a PCR value
> > + *
> >   * @chip:	TPM chip to use.
> >   * @pcr_idx:	index of the PCR.
> >   * @hash:	hash value to use for the extend operation.
> >   *
> > - * 0 is returned when the operation is successful. If a negative
> > number is
> > - * returned it remarks a POSIX error code. If a positive number is
> > returned
> > - * it remarks a TPM error.
> > + * Return:
> > + *     0 when the operation is successful
> > + *     A negative number for system errors (errno)
> > + *     A positive number for a TPM error.
> 
> Put this to tpm_transmit_cmd only and refer to that from other functions with
> "same as with tpm_transmit_cmd()" with parenthesis because that marks in rst
> a link to that function.

And then tpm_transmit_cmd() will point to tpm_transmit() ? 
I'm not sure I'm happy about those links, rst is okay but after all  mostly we're just looking directly to the sources with a simple editor. 
Anyhow this patch is to resolve the kdoc syntax bug, the overhaul of the documentation can be built on top of it. 

Thanks
Tomas
