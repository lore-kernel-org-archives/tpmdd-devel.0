From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/12] ima: measure digest lists instead of individual
 files
Date: Wed, 26 Jul 2017 17:54:18 -0400
Message-ID: <1501106058.28419.102.camel@linux.vnet.ibm.com>
References: <20170725154423.24845-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170725154423.24845-1-roberto.sassu@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>, linux-ima-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Roberto,

[cc'ing tpmdd-devel]

On Tue, 2017-07-25 at 17:44 +0200, Roberto Sassu wrote:
> This patch set applies on top of kernel v4.13-rc2.
> 
> IMA, for each file matching policy rules, calculates a digest, creates
> a new entry in the measurement list and extends a TPM PCR with the digest
> of entry data. The last step causes a noticeable performance reduction.
> 
> Since systems likely access the same files, repeating the above tasks at
> every boot can be avoided by replacing individual measurements of likely
> accessed files with only one measurement of their digests: the advantage
> is that the system performance significantly improves due to less PCR
> extend operations; on the other hand, the information about which files
> have exactly been accessed and in which sequence is lost.
> 
> If this new measurement reports only good digests (e.g. those of
> files included in a Linux distribution), and if verifiers only check
> that a system executed good software and didn't access malicious data,
> the disadvantages reported earlier would be acceptable.
> 
> The Trusted Computing paradigm measure & load is still respected by IMA
> with the proposed optimization. If a file being accessed is not in a
> measured digest list, a measurement will be recorded as before. If it is,
> the list has already been measured, and the verifier must assume that
> files with digest in the list have been accessed.
> 
> Measuring digest lists gives the following benefits:
> 
> - boot time reduction
>   For a minimal Linux installation with 1400 measurements, the boot time
>   decreases from 1 minute 30 seconds to 15 seconds, after loading to IMA
>   the digest of all files packaged by the distribution (32000). The new
>   list contains 92 entries. Without IMA, the boot time is 8.5 seconds.

Before we "fix" a TPM performance problem in IMA, we need to really
understand the performance problem first.  We've added a "TPM
peformance" topic to the Linux Plumber Conference TPM microconference
- http://wiki.linuxplumbersconf.org/2017:tpms.

We've benchmarked a couple of different TPMs on different systems with
TPMs on LPC, I2C, and STI.  Originally we were seeing even worse
performance than your 1 minute 30 seconds for 1400 measurements.
  Fortunately, we were able to bring it down to about 17 seconds for
a 1000 TPM extends.  Refer to commits a233a0289cf9 "tpm: msleep()
delays - replace with usleep_range() in i2c nuvoton driver" and
0afb7118ae02 "tpm: add sleep only for retry in
i2c_nuvoton_write_status()" for the details.

Hamza Attak posted a similar patch to the tpmdd-devel mailing list
replacing msleep() with usleep_range() calls.  Unfortunately, we're
seeing really poor performance with another TPM for other reasons.

Mimi

> 
> - lower network and CPU requirements for remote attestation
>   With the IMA optimization, both the measurement and digest lists
>   must be verified for a complete evaluation. However, since the lists
>   are fixed, they could be sent to and checked by the verifier only once.
>   Then, during a remote attestation, the only remaining task is to verify
>   the short measurement list.
> 
> - signature-based remote attestation
>   Digest list signature can be used as a proof of the provenance for the
>   files whose digest is in the list. Then, if verifiers trust the signer
>   and only check provenance, remote attestation verification would simply
>   consist on checking digest lists signatures and that the measurement
>   list only contain list metadata digests (reference measurement databases
>   would be no longer required). An example of a signed digest list,
>   that can be parsed with this patch set, is the RPM package header.
> 
> Digest lists are loaded in two stages by IMA through the new securityfs
> interface called 'digest_lists'. Users supply metadata, for the digest
> lists they want to load: path, format, digest, signature and algorithm
> of the digest.
> 
> Then, after the metadata digest is added to the measurement list, IMA
> reads the digest lists at the path specified and loads the digests in
> a hash table (digest lists are not measured, since their digest is already
> included in the metadata). With metadata measurement instead of digest list
> measurement, it is possible to avoid a performance reduction that would
> occur by measuring many digest lists (e.g. RPM headers) individually.
> If, alternatively, digest lists are loaded together, their signature
> cannot be verified.
> 
> Lastly, when a file is accessed, IMA searches the calculated digest in
> the hash table. Only if the digest is not found a new entry is added
> to the measurement list.
> 
> 
> Roberto Sassu (12):
>   ima: generalize ima_read_policy()
>   ima: generalize ima_write_policy()
>   ima: generalize policy file operations
>   ima: use ima_show_htable_value to show hash table data
>   ima: add functions to manage digest lists
>   ima: added parser of digest lists metadata
>   ima: added parser for compact digest list
>   ima: added parser for RPM data type
>   ima: introduce securityfs interfaces for digest lists
>   ima: disable digest lookup if digest lists are not measured
>   ima: don't report measurements if digests are included in the loaded
>     lists
>   ima: added Documentation/security/IMA-digest-lists.txt
> 
>  Documentation/security/IMA-digest-lists.txt | 150 +++++++++++++++++
>  include/linux/fs.h                          |   1 +
>  security/integrity/ima/Kconfig              |  11 ++
>  security/integrity/ima/Makefile             |   1 +
>  security/integrity/ima/ima.h                |  17 ++
>  security/integrity/ima/ima_digest_list.c    | 247 ++++++++++++++++++++++++++++
>  security/integrity/ima/ima_fs.c             | 178 ++++++++++++--------
>  security/integrity/ima/ima_main.c           |  23 ++-
>  security/integrity/ima/ima_policy.c         |   1 +
>  security/integrity/ima/ima_queue.c          |  39 +++++
>  10 files changed, 602 insertions(+), 66 deletions(-)
>  create mode 100644 Documentation/security/IMA-digest-lists.txt
>  create mode 100644 security/integrity/ima/ima_digest_list.c
> 
