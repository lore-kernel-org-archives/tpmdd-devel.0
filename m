From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 0/5] Updated API for TPM 2.0 PCR extend
Date: Fri, 5 May 2017 16:21:47 +0200
Message-ID: <20170505142152.29795-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The first version of the patch set can be retrieved at the URL:

https://sourceforge.net/p/tpmdd/mailman/message/35756302/

The patches in this set should be applied on top of the patch set
'tpm_pcr_extend() code split', which can be retrieved at the URL:

https://sourceforge.net/p/tpmdd/mailman/message/35820107/

This patch set updates the TPM driver API for extending Platform
Configuration Registers (PCRs). These are special TPM registers which
cannot be written directly, but can only be updated through the extend
operation, by passing a digest as input:

PCR_value_new = hash_func(PCR_value_old | digest)

While TPM 1.2 can only use SHA1 as hash function, TPM 2.0 can support
multiple algorithms. In the second case, PCR values extended with the same
algorithm are stored in a location called bank.

The primary use of the PCR extend operation is to protect the integrity
of measurements (e.g. of kernel, initial ram disk, application binaries),
which can be used by remote verifiers to determine if the software
running on a platform can be trusted to produce the expected outputs.
An example of software performing such measurements is Integrity
Measurement Architecture (IMA), which implements a set of hooks called
each time a subset of system calls, e.g. execve() or open(), is executed.

When IMA performs a measurement, it extends a PCR with the digest of a
measurement event log. The extend operation guarantees that modifications
of the measurements list can always be detected. Since PCRs cannot be
reverted to a previous value, it won't be possible for an attacker to hide
his actions by removing one of the log entries, because remote verifiers
would obtain a different value by replicating the extend operation with
the event log digests.

Currently, PCRs can only be extended from the kernel with a SHA1 digest,
through tpm_pcr_extend(). Remaining banks of a TPM 2.0 are extended with
the SHA1 digest padded with zeros. In order to take advantage of stronger
algorithms, IMA must be able to pass to the TPM driver interface digests
of different lengths. The second requirement comes from the TCG consortium,
which recommends to extend all banks, to prevent attackers from misusing
them. The third requirement is that TPM users should be able to obtain
from the driver interface TPM algorithm IDs, in order to produce an event
log with the format defined by TCG.

This patch set:

1) introduces tpm_pcr_algorithms(), to obtain the IDs of the algorithms
   supported by the TPM (TPM2_ALG_SHA1 is returned for TPM 1.2)

2) introduces tpm_pcr_algo_to_crypto() and tpm_pcr_algo_from_crypto() to
   convert TPM IDs to crypto IDs (in order to calculate the digest of
   an event log with the crypto subsystem), and vice-versa

3) modifies the parameters of tpm_pcr_extend(), to pass multiple digests

4) modifies the callers of tpm_pcr_extend(), to pass the correct arguments:
   - pcrlock() in security/keys/trusted.c
   - ima_pcr_extend() in security/integrity/ima/ima_queue.c

Given this definition of the tpm2_digest structure:

struct tpm2_digest {
	u16 alg_id;
	u8 digest[SHA512_DIGEST_SIZE];
} __packed;

these are the two methods to extend PCRs:

1) by passing only one tpm2_digest structure containing a SHA1 digest
   (as it is done in the patches 4/5 and 5/5); in this case, the SHA1
   digest is padded with zeros (current behavior)

2) by calling tpm_pcr_algorithms() to obtain the algorithms supported by
   the TPM, and by calling tpm_pcr_extend() with as many tpm2_digest
   structures as the number of algorithms retrieved in the first step


API Usage Examples

In the following examples, an application extends PCR 16 with the digest
of an event (e.g. record of a software measurement), with the methods
described above.

void app_calc_event_digest(struct crypto_shash *tfm, char *event,
                           u8 *digest)
{
    SHASH_DESC_ON_STACK(shash, tfm);

    shash->tfm = tfm;
    shash->flags = 0;

    crypto_shash_init(shash);
    crypto_shash_update(shash, event, strlen(event));
    crypto_shash_final(shash, digest);
}

void app_pcr_extend_method_1(void)
{
    char *event = "application event";
    struct tpm2_digest digestarg = {.alg_id = TPM2_ALG_SHA1};

    /* calculate event digest with current hash algorithm */
    struct crypto_shash *tfm = crypto_alloc_shash("sha1", 0, 0);

    app_calc_event_digest(tfm, event, digestarg.digest);

    /* extend all PCR banks with SHA1 digest*/
    tpm_pcr_extend(TPM_ANY_NUM, 16, 1, &digestarg);
}

void app_pcr_extend_method_2(void)
{
    /* declare static arrays, limit is known */
    enum tpm2_algorithms algo_array[TPM_ACTIVE_BANKS_MAX];
    struct tpm2_digest digest_array[TPM_ACTIVE_BANKS_MAX];
    int i, num_algo;

    /* obtain algorithms supported by the TPM */
    num_algo = tpm_pcr_algorithms(TPM_ANY_NUM, ARRAY_SIZE(algo_array),
                                  algo_array);

    for (i = 0; i < num_algo; i++) {
        char *event = "application event";

        /* convert TPM ID to crypto ID to calculate the digest */
        unsigned int crypto_id = tpm_pcr_algo_to_crypto(algo_array[i]);

        /* calculate event digest with current hash algorithm */
        const char *algo_name = hash_algo_name[crypto_id];
        struct crypto_shash *tfm = crypto_alloc_shash(algo_name, 0, 0);

        app_calc_event_digest(tfm, event, digest_array[i].digest);
        digest_array[i].alg_id = algo_array[i];
    }

    /* extend all PCR banks with calculated digests */
    tpm_pcr_extend(TPM_ANY_NUM, 16, num_algo, digest_array);
}

Changelog:

v2

- removed tpm2_digests_all_banks(); input check is now done by
  tpm_pcr_check_input(), called by tpm_pcr_extend(), also for TPM 1.2
- fixed return values of tpm2_pcr_algo_to_crypto() and
  tpm2_pcr_algo_from_crypto() if TPM is not supported
- tpm_pcr_algorithms() returns supported algorithms also for TPM 1.2
- removed tpm_pcr_extend_digests()
- modified parameters of tpm_pcr_extend()
- modified callers of tpm_pcr_extend()

Roberto Sassu (5):
  tpm: introduce tpm_pcr_algorithms()
  tpm: introduce tpm_pcr_algo_to_crypto() and tpm_pcr_algo_from_crypto()
  tpm: pass multiple digests to tpm_pcr_extend()
  keys, trusted: modify arguments of tpm_pcr_extend()
  ima: modify arguments of tpm_pcr_extend()

 drivers/char/tpm/tpm-interface.c   | 173 +++++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpm.h             |  19 +---
 drivers/char/tpm/tpm2-cmd.c        |  42 +++------
 include/linux/tpm.h                |  43 ++++++++-
 security/integrity/ima/ima_queue.c |   4 +-
 security/keys/trusted.c            |   6 +-
 6 files changed, 227 insertions(+), 60 deletions(-)

-- 
2.9.3

