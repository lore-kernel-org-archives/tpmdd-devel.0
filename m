From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 0/6] Updated API for TPM 2.0 PCR extend
Date: Wed, 28 Jun 2017 20:10:43 +0300
Message-ID: <20170628171043.uqlx6roznq4tqpwv@linux.intel.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
 <20170624090325.kbqhwkrx5qvtxveg@linux.intel.com>
 <989430a6-973f-6610-fb0a-f9e4b01b0d8e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <989430a6-973f-6610-fb0a-f9e4b01b0d8e@huawei.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 26, 2017 at 09:21:46AM +0200, Roberto Sassu wrote:
> On 6/24/2017 11:03 AM, Jarkko Sakkinen wrote:
> > On Wed, Jun 21, 2017 at 04:29:35PM +0200, Roberto Sassu wrote:
> > > The first version of the patch set can be retrieved at the URL:
> > > 
> > > https://sourceforge.net/p/tpmdd/mailman/message/35756302/
> > > 
> > > The patches should be applied on top of the next branch of
> > > linux-security.git (commit cdac74d).
> > > 
> > > This patch set updates the TPM driver API for extending Platform
> > > Configuration Registers (PCRs). These are special TPM registers which
> > > cannot be written directly, but can only be updated through the extend
> > > operation, by passing a digest as input:
> > > 
> > > PCR_value_new = hash_func(PCR_value_old | digest)
> > > 
> > > While TPM 1.2 can only use SHA1 as hash function, TPM 2.0 can support
> > > multiple algorithms. On a TPM 2.0, PCR values extended with the same
> > > algorithm are stored in a location called bank.
> > > 
> > > Currently, PCRs can only be extended from the kernel with a SHA1 digest,
> > > through tpm_pcr_extend(). Remaining banks of a TPM 2.0 are extended with
> > > the SHA1 digest padded with zeros. In order to take advantage of stronger
> > > algorithms, the TPM driver should allow TPM users to extend a PCR with
> > > digests calculated with the same algorithm of the PCR bank.
> > > 
> > > This patch set first introduces a new structure, called tpm_pcr_bank_info,
> > > for storing detailed information about each PCR bank:
> > > 
> > > - TPM algorithm ID: algorithm identifier, defined by TCG; will be included
> > >   by TPM users (e.g. IMA) in a measurement event log
> > > - digest size: digest size for a TPM algorithm; since this is retrieved
> > >   from the TPM, PCR banks can be extended even if an algorithm is unknown
> > >   for the crypto subsystem (which currently the TPM driver relies on)
> > > - crypto ID: will be used by TPM users to calculate a digest, to extend
> > >   a PCR
> > > 
> > > Then, the patch set introduces the new function tpm_get_pcr_banks_info(),
> > > to pass the information about PCR banks to TPM users, and finally, modifies
> > > the parameters of tpm_pcr_extend(), so that TPM users can pass multiple
> > > digests.
> > > 
> > > Given this definition of the tpm2_digest structure:
> > > 
> > > struct tpm2_digest {
> > >     u16 alg_id;
> > >     u8 digest[SHA512_DIGEST_SIZE];
> > > } __packed;
> > > 
> > > there will be two methods to extend PCRs:
> > > 
> > > 1) by passing only one tpm2_digest structure containing a SHA1 digest
> > >    (as it is done in the patch 6/6); in this case, the SHA1 digest
> > >    is padded with zeros
> > > 
> > > 2) by calling tpm_get_pcr_banks_info() to obtain PCR banks information,
> > >    and by calling tpm_pcr_extend() with as many tpm2_digest structures as
> > >    the number of tpm_pcr_bank_info structures retrieved in the first step
> > >    (if a digest for a TPM algorithm is missing, the TPM driver
> > >    pads/truncates the first digest provided by the TPM user)
> > > 
> > > 
> > > API Usage Examples
> > > 
> > > In the following examples, an application extends PCR 16 with the digest
> > > of an event (e.g. record of a software measurement), with the methods
> > > described above.
> > > 
> > > 
> > > void app_calc_event_digest(struct crypto_shash *tfm, char *event,
> > >                            u8 *digest)
> > > {
> > >     SHASH_DESC_ON_STACK(shash, tfm);
> > > 
> > >     shash->tfm = tfm;
> > >     shash->flags = 0;
> > > 
> > >     crypto_shash_init(shash);
> > >     crypto_shash_update(shash, event, strlen(event));
> > >     crypto_shash_final(shash, digest);
> > > }
> > > 
> > > void app_pcr_extend_method_1(void)
> > > {
> > >     char *event = "application event";
> > >     struct tpm2_digest digestarg = {.alg_id = TPM2_ALG_SHA1};
> > > 
> > >     /* calculate event digest with current hash algorithm */
> > >     struct crypto_shash *tfm = crypto_alloc_shash("sha1", 0, 0);
> > > 
> > >     app_calc_event_digest(tfm, event, digestarg.digest);
> > > 
> > >     /* extend all PCR banks with SHA1 digest*/
> > >     tpm_pcr_extend(TPM_ANY_NUM, 16, 1, &digestarg);
> > > }
> > > 
> > > void app_pcr_extend_method_2(void)
> > > {
> > >     /* declare static arrays, limit is known */
> > >     struct tpm_pcr_bank_info active_banks[TPM_ACTIVE_BANKS_MAX];
> > >     struct tpm2_digest digest_array[TPM_ACTIVE_BANKS_MAX];
> > >     int i, num_algo;
> > > 
> > >     /* obtain algorithms supported by the TPM */
> > >     num_algo = tpm_get_pcr_banks_info(TPM_ANY_NUM, active_banks);
> > > 
> > >     for (i = 0; i < num_algo; i++) {
> > >         char *event = "application event";
> > > 
> > >         /* calculate event digest with current hash algorithm */
> > >         const char *algo_name = hash_algo_name[active_banks[i].crypto_id];
> > >         struct crypto_shash *tfm = crypto_alloc_shash(algo_name, 0, 0);
> > > 
> > >         app_calc_event_digest(tfm, event, digest_array[i].digest);
> > >         digest_array[i].alg_id = active_banks[i].alg_id;
> > >     }
> > > 
> > >     /* extend all PCR banks with calculated digests */
> > >     tpm_pcr_extend(TPM_ANY_NUM, 16, num_algo, digest_array);
> > > }
> > > 
> > > 
> > > Changelog
> > > 
> > > v3
> > > 
> > > - introduced new structure tpm_pcr_bank_info
> > > - read a PCR to obtain the digest size for each TPM algorithm
> > > - tpm_pcr_algorithms() replaced by tpm_get_pcr_banks_info()
> > > - removed tpm_pcr_algo_to_crypto() and tpm_pcr_algo_from_crypto()
> > > - modification of tpm_pcr_extend() parameters and of callers of the
> > >   function done in the same patch
> > > - removed tpm_pcr_check_input()
> > > 
> > > v2
> > > 
> > > - tpm_pcr_algorithms() returns supported algorithms also for TPM 1.2
> > > - fixed return values of tpm2_pcr_algo_to_crypto() and
> > >   tpm2_pcr_algo_from_crypto() if TPM support is disabled in the kernel
> > > - tpm_pcr_extend() arguments checked by tpm_pcr_check_input()
> > > - modified parameters of tpm_pcr_extend()
> > > 
> > > Roberto Sassu (6):
> > >   tpm: use tpm_buf functions to perform a PCR read
> > >   tpm: use tpm2_pcr_read_tpm_buf() in tpm2_do_selftest()
> > >   tpm: introduce tpm_pcr_bank_info structure with digest_size from TPM
> > >   tpm: replace TPM algorithms IDs with tpm_pcr_bank_info structs in
> > >     tpm_chip
> > >   tpm: introduce tpm_get_pcr_banks_info()
> > >   tpm: pass multiple digests to tpm_pcr_extend()
> > > 
> > >  drivers/char/tpm/tpm-interface.c   |  88 ++++++++++++++++++++++---
> > >  drivers/char/tpm/tpm.h             |  19 +-----
> > >  drivers/char/tpm/tpm2-cmd.c        | 132 ++++++++++++++++++++++---------------
> > >  include/linux/tpm.h                |  39 ++++++++++-
> > >  security/integrity/ima/ima_queue.c |   4 +-
> > >  security/keys/trusted.c            |   6 +-
> > >  6 files changed, 202 insertions(+), 86 deletions(-)
> > > 
> > > --
> > > 2.9.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe keyrings" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> > To move this forward and be more constructive here's how I see it
> > should be done (along the lines, draft):
> > 
> > int tpm_pcr_extend(u32 chip_num, int pcr_idx, unsigned int alg,
> > 		   const u8 *hash);
> > 
> > The paramater 'alg' is crypto ID as specified by crypto subsystem.
> 
> You cannot pass one digest at time. Suppose that you want to extend
> the SHA1 and SHA256 banks, each with a digest calculated with the
> same algorithm. If you pass a SHA1 digest first, also the SHA256 bank
> will be extended with the padded SHA1 digest.

Is this required by IMA somehow? Don't really understand the scenario
where you would extend first with SHA1 and subsequently with SHA256.

> Regarding crypto IDs, it has been decided that IMA will include
> TPM algorithm IDs in the event log. So both IDs should be passed
> to IMA somehow.

Don't really understand why TPM algorithm IDs are so important for IMA.

> Roberto

/Jarkko
