From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4 V2] tpm/tpm_crb: implement power
	management.
Date: Mon, 12 Sep 2016 11:54:57 +0300
Message-ID: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Te overall platform ability to enter a low power state is also
conditioned on the ability of a tpm device to go to idle state.
This series should provide this feature.

Unfortunately, there is a HW bug on Intel PTT devices on Skylake,
Kabylake, and Broxton devices, where certain registers lost retention
during TPM idle state. Hence this implementation takes this into
consideration and implement the feature based only on access to
registers that retain their state. This still conforms to the spec
and should be correct also on non Intle devices.

V2: Utilize runtime_pm for driving tpm crb idle states.


Tomas Winkler (4):
  tpm/tpm_crb: implement tpm crb idle state
  tmp/tpm_crb: fix Intel PTT hw bug during idle state
  tpm/tpm_crb: open code the crb_init into acpi_add
  tmp/tpm_crb: implment runtime pm for tpm_crb

 drivers/char/tpm/tpm-interface.c |   5 ++
 drivers/char/tpm/tpm_crb.c       | 166 +++++++++++++++++++++++++++++++++------
 2 files changed, 147 insertions(+), 24 deletions(-)

-- 
2.7.4


------------------------------------------------------------------------------
