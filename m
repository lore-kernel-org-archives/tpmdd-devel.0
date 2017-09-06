From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 0/4] additional TPM performance improvements
Date: Wed,  6 Sep 2017 08:56:35 -0400
Message-ID: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: patrickc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

After further discussions with the Device Driver working group (ddwg),
the following changes were made: 

* Check for burstcount at least once to confirm the TPM is ready to accept
the data. Similarly, query for the TPM Expect status as sanity check at
the end.

* Make the sleep for status check during send() in the loop less than
5msec.

* Make the sleep in the loop while querying for burstcount less than
5msec.

Below is the list of patches along with the performance improvements
seen with a TPM 1.2 with an 8 byte burstcount for 1000 extends: 

Patch                                        |Improvement(time in sec)

tpm: ignore burstcount to improve tpm_tis    | ~41 - ~14
send() performance.

tpm: define __wait_for_tpm_stat to specify   | ~14 - ~10
variable polling sleep time

tpm: reduce tpm_msleep() time in             | ~10 - ~9
get_burstcount()

tpm: modify tpm_msleep() function to have    | ~9 - ~8
max range

Changelog v2:

* Add module parameter to handle ignoring of burst count during
tpm tis send() operation.
* Add improvements over sleep time to reduce delays.

Nayna Jain (4):
  tpm: ignore burstcount to improve tpm_tis send() performance.
  tpm: define __wait_for_tpm_stat to specify variable polling sleep time
  tpm: reduce tpm_msleep() time in get_burstcount()
  tpm: use tpm_msleep() value as max delay

 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++
 drivers/char/tpm/tpm-interface.c                | 15 ++++++++--
 drivers/char/tpm/tpm.h                          |  7 +++--
 drivers/char/tpm/tpm_tis_core.c                 | 37 +++++++++++++++++++------
 4 files changed, 53 insertions(+), 14 deletions(-)

-- 
2.13.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
