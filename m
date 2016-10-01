From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/2] Clean up handling of event log files
Date: Sat, 1 Oct 2016 15:44:56 +0300
Message-ID: <20161001124456.GA25373@intel.com>
References: <1475325678-16573-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475325678-16573-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Please ignore this version. I was going to do a '--dry-run'. Sorry :(

Doing resend later on once I've tested the changes.

/Jarkko

On Sat, Oct 01, 2016 at 03:41:15PM +0300, Jarkko Sakkinen wrote:
> Meld a common function for opening measurements files and keep the
> dentries in a static array.
> 
> Jarkko Sakkinen (1):
>   tpm: replace dynamically allocated bios_dir with a static array
> 
> Nayna Jain (1):
>   tpm: define a generic open() method for ascii & bios measurements
> 
>  drivers/char/tpm/tpm-chip.c     |   9 +--
>  drivers/char/tpm/tpm.h          |   3 +-
>  drivers/char/tpm/tpm_eventlog.c | 123 ++++++++++++++--------------------------
>  drivers/char/tpm/tpm_eventlog.h |  10 ++--
>  4 files changed, 55 insertions(+), 90 deletions(-)
> 
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
