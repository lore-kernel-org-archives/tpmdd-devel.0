From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 1/5] tpm: introduce tpm_pcr_algorithms()
Date: Sat, 20 May 2017 16:18:46 +0300
Message-ID: <20170520131846.e3niqiknlrttbdf4@intel.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
 <20170505142152.29795-2-roberto.sassu@huawei.com>
 <20170515103623.sumyo2vyldezual2@intel.com>
 <d2974dd2-e30d-e8f0-a60a-2147f3290670@huawei.com>
 <8aacf9c7-ac99-578e-ca60-6bb45bf3ab2b@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8aacf9c7-ac99-578e-ca60-6bb45bf3ab2b@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 17, 2017 at 10:42:35AM +0200, Roberto Sassu wrote:
> On 5/15/2017 3:18 PM, Roberto Sassu wrote:
> > 
> > 
> > On 5/15/2017 12:36 PM, Jarkko Sakkinen wrote:
> > > On Fri, May 05, 2017 at 04:21:48PM +0200, Roberto Sassu wrote:
> > > > This function allows TPM users to know which algorithms the TPM
> > > > supports.
> > > > It stores the algorithms in a static array of 'enum tpm2_algorithms',
> > > > allocated by the caller. If the array is not large enough, the function
> > > > returns an error. Otherwise, it returns the number of algorithms written
> > > > to the array. If the TPM version is 1.2, the function writes
> > > > TPM2_ALG_SHA1
> > > > to first element of the array.
> > > > 
> > > > Writing the algorithm also for TPM 1.2 has the advantage that callers
> > > > can use the API, tpm_pcr_algorithms() and tpm_pcr_extend(), regardless
> > > > of the TPM version.
> > > > 
> > > > A minor change added to this patch was to make available the size of
> > > > the active_banks array, member of the tpm_chip structure, outside
> > > > the TPM driver. The array size (TPM_ACTIVE_BANKS_MAX) has been exported
> > > > to include/linux/tpm.h.
> > > > 
> > > > With this information, callers of tpm_pcr_algorithms() can provide
> > > > a static array with enough room for all the algorithms, instead
> > > > of receiving the pointer of a dynamic array that they have to free
> > > > later.
> > > > 
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > > v2
> > > > 
> > > > - tpm_pcr_algorithms() returns supported algorithms also for TPM 1.2
> > > > 
> > > >  drivers/char/tpm/tpm-interface.c | 46
> > > > ++++++++++++++++++++++++++++++++++++++++
> > > >  drivers/char/tpm/tpm.h           | 13 +-----------
> > > >  include/linux/tpm.h              | 19 +++++++++++++++++
> > > >  3 files changed, 66 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm-interface.c
> > > > b/drivers/char/tpm/tpm-interface.c
> > > > index 4ed08ab..b90de3d 100644
> > > > --- a/drivers/char/tpm/tpm-interface.c
> > > > +++ b/drivers/char/tpm/tpm-interface.c
> > > > @@ -911,6 +911,52 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx,
> > > > const u8 *hash)
> > > >  EXPORT_SYMBOL_GPL(tpm_pcr_extend);
> > > > 
> > > >  /**
> > > > + * tpm_pcr_algorithms - get TPM IDs of active PCR banks algorithms
> > > 
> > > The grammar is incorrect here I believe. Should rather be
> > > 
> > >   "algorithms of the active PCR banks"
> > > 
> > > And there is no such thing as "TPM ID".
> > > 
> > > > + * @chip_num:    tpm idx # or ANY
> > > > + * @count:    # of items in algorithms
> > > > + * @algorithms:    array of TPM IDs
> > > > + *
> > > > + * Returns < 0 on error, and the number of active PCR banks on success.
> > > > + *
> > > > + * TPM 1.2 has always one SHA1 bank.
> > > > + */
> > > > +int tpm_pcr_algorithms(u32 chip_num, int count,
> > > > +               enum tpm2_algorithms *algorithms)
> > >                        unsigned int
> > > 
> > > In addition the function name is not too greatg,
> > > 
> > > Your syntax for return value is not correct. In addition after
> > > describing the return value there should not be anything. You should
> > > study
> > > 
> > > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> > > 
> > > Better name for the function would be tpm_get_pcr_algorithms().
> > > 
> > > > +{
> > > > +    struct tpm_chip *chip;
> > > > +    int i;
> > > > +
> > > > +    if (count <= 0 || algorithms == NULL)
> > > > +        return -EINVAL;
> > > 
> > > Is there a legal case where caller would pass these values? Now it
> > > looks like that there is.
> > > 
> > > 'count' should unsigned int and zero should be a legal value for
> > > count.
> > 
> > I wanted to avoid that a negative value returned by tpm_pcr_algorithms()
> > is passed to tpm_pcr_extend() as unsigned int.
> > 
> > 
> > > That said I think the whole design is wrong as you could calculate
> > > array for algs only one time and pass a const reference to it on
> > > request.
> > 
> > Ok. If I understood it correctly, you are saying to pass a const
> > reference of chip->active_banks. Then, I should also:
> 
> This is not a viable option. chip could be freed and the reference
> becomes invalid, without increasing the reference count.
> 
> Did you think about something different?
> 
> Thanks
> 
> Roberto

Two alternatives come in mind.

1. add tpm_put to linclude/linux/tpm.h
2. take put_ops away from the implementation
3. add documentation that tpm_put needs to be called

or acceptable alternative would memcpy in the implementation

In any case, you should probably drop completely 'count' and have
function for getting the number of active banks.

/Jarkko
