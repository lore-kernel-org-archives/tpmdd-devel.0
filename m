From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] tpm_tis: convert to using
	locality callbacks
Date: Mon, 27 Mar 2017 08:28:01 +0300
Message-ID: <20170327052801.pj6euzlg2bthrkin@intel.com>
References: <20170325200521.19224-1-jsnitsel@redhat.com>
	<20170325200521.19224-2-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170325200521.19224-2-jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 25, 2017 at 01:05:21PM -0700, Jerry Snitselaar wrote:
> This patch converts tpm_tis to use of the new tpm class ops
> request_locality, and relinquish_locality.
> 
> With the move to using the callbacks, release_locality is changed so
> that we now release the locality even if there is no request pending.
> 
> This required some changes to the tpm_tis_core_init code path to
> make sure locality is requested when needed:
> 
>   - tpm2_probe code path will end up calling request/release through
>     callbacks, so request_locality prior to tpm2_probe not needed.
> 
>   - probe_itpm makes calls to tpm_tis_send_data which no longer calls
>     request_locality, so add request_locality prior to tpm_tis_send_data
>     calls. Also drop release_locality call in middleof probe_itpm, and
>     keep locality until release_locality called at end of probe_itpm.
> 
> Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
> Signed-off-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_tis_core.c | 35 +++++++++--------------------------
>  1 file changed, 9 insertions(+), 26 deletions(-)

LGTM except what Jason said earlier.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
