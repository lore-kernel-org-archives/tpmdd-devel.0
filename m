From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: tpm: Provide a TPM access library
Date: Tue, 21 Aug 2018 16:56:49 +0100
Message-ID: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


Hi Denis, Jarkko, James,

I managed to recover the TPM library patchset that I was working on about four
years ago in the process of trying to write an asymmetric key subtype that
could use the TPM.

Here it is in it's original glory for reference.  I ended up leaving it
because Jarkko's tpm-2 stuff broke it and I had other things to work on.  If
it's deemed worthwhile, I can try to forward port it to current Linus/mastet.

Note that one or two of the preliminary patches may be upstream.

The patches can also be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=tpm-lib

Thanks,
David
---
David Howells (23):
      TPM: Add new TPMs to the tail of the list to prevent inadvertent change of dev
      TPM: Provide a facility for a userspace TPM emulator
      TPM: Provide a platform driver for the user emulator driver
      TPM: Expose struct tpm_chip and related find_get and put functions
      TPM: Use struct tpm_chip rather than chip number as interface parameter
      TPM: Move ordinal values from interface file to header with other ordinals
      TPM: Consolidate tpm_send(), transmit_cmd() and tpm_transmit()
      TPMLIB: Break TPM bits out of security/keys/trusted.c
      TPMLIB: Do some source cleanups
      TPMLIB: Better format calls to TSS_*hmac*()
      TPMLIB: Put banner comments on public TPM library functions
      TPMLIB: Create tpm_{even,odd}_nonce structs to represent nonces
      TPMLIB: Rename store8() and storebytes()
      TPMLIB: Make store_s() take a void* data argument, not unsigned char*
      TPMLIB: Use __be32 rather than int32_t and use cpu_to_beX() and co.
      TPMLIB: Put more comments into the HMAC generation functions
      TPMLIB: Provide a wrapper to load bytes out of the reply
      TPMLIB: Encapsulate XOR-based encryption with authkey derivative
      TPMLIB: Add some debugging code
      TPMLIB: Implement call to TPM_CreateWrapKey
      TPMLIB: Implement call to TPM_LoadKey2
      TPMLIB: Provide call for TPM_FlushSpecific
      TPM: Add an asymmetric key subtype for handling TPM-based keys


 crypto/asymmetric_keys/Kconfig          |    7 
 crypto/asymmetric_keys/Makefile         |    1 
 crypto/asymmetric_keys/tpm_key.c        |   73 ++
 crypto/asymmetric_keys/tpm_key.h        |   19 
 crypto/asymmetric_keys/tpm_key_parser.c |  212 +++++
 drivers/char/tpm/Kconfig                |   13 
 drivers/char/tpm/Makefile               |    3 
 drivers/char/tpm/tpm-dev.c              |   17 
 drivers/char/tpm/tpm-interface.c        |  304 ++++----
 drivers/char/tpm/tpm-library.c          | 1216 +++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-library.h          |  119 +++
 drivers/char/tpm/tpm-sysfs.c            |   33 -
 drivers/char/tpm/tpm.h                  |   15 
 drivers/char/tpm/tpm_infineon.c         |    6 
 drivers/char/tpm/tpm_user_emul.c        |  694 ++++++++++++++++++
 include/linux/tpm.h                     |  123 +++
 include/linux/tpm_command.h             |   22 -
 include/linux/wait.h                    |   11 
 security/integrity/ima/ima.h            |    2 
 security/integrity/ima/ima_crypto.c     |    4 
 security/integrity/ima/ima_init.c       |   19 
 security/integrity/ima/ima_queue.c      |    4 
 security/keys/trusted.c                 |  690 +-----------------
 security/keys/trusted.h                 |   80 --
 24 files changed, 2712 insertions(+), 975 deletions(-)
 create mode 100644 crypto/asymmetric_keys/tpm_key.c
 create mode 100644 crypto/asymmetric_keys/tpm_key.h
 create mode 100644 crypto/asymmetric_keys/tpm_key_parser.c
 create mode 100644 drivers/char/tpm/tpm-library.c
 create mode 100644 drivers/char/tpm/tpm-library.h
 create mode 100644 drivers/char/tpm/tpm_user_emul.c


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
