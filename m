From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 0/2] Avoid sending invalid data to
 the TPM
Date: Fri, 25 Aug 2017 19:44:16 +0300
Message-ID: <20170825164416.svo7khm4zsmosxbx@linux.intel.com>
References: <20170824083545.13280-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824083545.13280-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 24, 2017 at 10:35:43AM +0200, Alexander Steffen wrote:
> When trying to send invalid commands (with mismatching commandSize values)
> to the TPM we discovered some cases in which data is sent to the TPM that
> should not be sent there. Similar problems were fixed years ago, but this
> one slipped through it seems.
> 
> Alexander Steffen (2):
>   tpm-dev-common: Reject too short writes
>   tpm-interface: Fix checks of buffer size
> 
>  drivers/char/tpm/tpm-dev-common.c |  2 +-
>  drivers/char/tpm/tpm-interface.c  | 16 ++++++++--------
>  drivers/char/tpm/tpm.h            |  3 ++-
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> -- 
> 2.7.4
> 

Have you checked that these do no break /dev/tpmrm0?

I have some cheap unit tests here to smoke it:

https://github.com/jsakkine-intel/tpm2-scripts

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
