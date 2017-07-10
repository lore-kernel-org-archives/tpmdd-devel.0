From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] msleep() delays - replace with
 usleep_range() in TPM 1.2/2.0 generic drivers
Date: Mon, 10 Jul 2017 22:15:27 +0300
Message-ID: <20170710191527.qlurrqit6naoaotp@linux.intel.com>
References: <DF4PR84MB0028CFD4B5EBE9F929B83476F2A90@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DF4PR84MB0028CFD4B5EBE9F929B83476F2A90-g2Ljlah8a+id4EXwv3iukNicc1VoeDReZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Attak, Hamza" <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Cc: "Jacquin, Ludovic" <ludo-ZPxbGqLxI0U@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Edwards, Nigel" <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jul 10, 2017 at 01:26:51PM +0000, Attak, Hamza wrote:
> msleep() delays - replace with usleep_range() in TPM 1.2/2.0 generic drivers
> 
> Following the recent Nuvoton patch submitted by Mimi Zohar:
> https://sourceforge.net/p/tpmdd/mailman/message/35685260/

1. Please do not your work on a patch that was never applied.
   This one was https://patchwork.kernel.org/patch/9617835/ 
2. Please break your lines properly in the commit message
3. Please use commit ID in the mainline instead of URL.

Have you run scripts/checkpatch.pl?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
