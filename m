From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [Linux-ima-devel] [PATCH v2 3/5] tpm: pass multiple digests to
 tpm_pcr_extend()
Date: Tue, 30 May 2017 07:25:47 -0400
Message-ID: <1496143547.3841.517.camel@linux.vnet.ibm.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
         <20170505142152.29795-4-roberto.sassu@huawei.com>
         <1496114943.3841.480.camel@linux.vnet.ibm.com>
         <97c6930e-8b4d-9578-e210-68987e4d7503@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <97c6930e-8b4d-9578-e210-68987e4d7503@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-05-30 at 09:28 +0200, Roberto Sassu wrote:
> On 5/30/2017 5:29 AM, Mimi Zohar wrote:
> > On Fri, 2017-05-05 at 16:21 +0200, Roberto Sassu wrote:


> >> @@ -876,29 +925,46 @@ static int tpm1_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash,
> >>   * isn't, protect against the chip disappearing, by incrementing
> >>   * the module usage count.
> >>   */
> >> -int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
> >> +int tpm_pcr_extend(u32 chip_num, int pcr_idx, int count,
> >> +		   struct tpm2_digest *digests)
> >>  {
> >>  	int rc;
> >>  	struct tpm_chip *chip;
> >>  	struct tpm2_digest digest_list[ARRAY_SIZE(chip->active_banks)];
> >> -	u32 count = 0;
> >> +	struct tpm2_digest *digests_ptr = digests;
> >> +	u32 filled_count = 0;
> >> +	u8 *hash;
> >>  	int i;
> >>
> >>  	chip = tpm_chip_find_get(chip_num);
> >>  	if (chip == NULL)
> >>  		return -ENODEV;
> >>
> >> -	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> >> +	rc = tpm_pcr_check_input(chip, count, digests);
> >> +	if (rc < 0) {
> >> +		dev_dbg(&chip->dev, "%s: invalid arguments\n", __func__);
> >> +		tpm_put_ops(chip);
> >
> > This rejects the TPM extend, if ANY of the algorithms are unknown.
> > Suppose that the standards were updated, TPM vendors add support for
> > the new algorithm, but the kernel has not been updated to reflect the
> > new algorithms supported.  As the measurement hash already been added
> > to the IMA measurement list, verifying the measurement list against a
> > TPM quote will fail, not just for the unknown algorithm, but for all
> > algorithms.  Something is very broken with this approach.
> 
> The alternative is to extend remaining banks with a digest,
> for example the first passed by the caller. I will modify
> the patch, if everyone agrees on that.

The solution you're proposing is similar to the original solution of
extending the TPM with a padded/truncated SHA1 hash, but this time it
might not be a padded/truncated SHA1 hash, but a different algorithm.
So the attestation server will then need to know which hash algorithm
was used to extend each of the TPM banks - a padded/truncated digest
value or the real digest value.

The only issue, from the kernel's perspective, will be determining the
algorithm's digest size as the kernel has no knowledge of it.  On TPM
registration/initialization, if you're not already querying the TPM
for the algorithm digest sizes, you will need to do so.

Mimi

