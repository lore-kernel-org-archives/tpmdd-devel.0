From: "Attak, Hamza" <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH] msleep() delays - replace with
 usleep_range() in TPM 1.2/2.0 generic drivers
Date: Wed, 12 Jul 2017 12:33:17 +0000
Message-ID: <DF4PR84MB00282954917EE6C723C04F11F2AF0@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
References: <DF4PR84MB0028CFD4B5EBE9F929B83476F2A90@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
	<20170710191527.qlurrqit6naoaotp@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170710191527.qlurrqit6naoaotp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Jacquin, Ludovic" <ludo-ZPxbGqLxI0U@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Edwards, Nigel" <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

1. I guess you meant not to "base" my work on an unapplied patch. The patch we
   are submitting is not dependant on the referenced, earlier patch.
   It is also not including any of its changes. The former patch was only
   mentioned to give context, as it is a similar approach, however it is 
   addressing another problem (Nuvoton driver). This reference can as well be
   removed if misleading.
2. Linebreaks in commit message should be fixed now.
3. The URL has been removed, so as the reference to the former patch.

No, I didn't run checkpatch.pl when first submitting the patch. Testing it with
checkpatch.pl, the output gave me warning about lines over 80 chars. They are
now solved.
I am sending an updated version of the patch.

Thanks,
Hamza ATTAK.


-----Original Message-----
From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org] 
Sent: 10 July 2017 20:15
To: Attak, Hamza <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Jacquin, Ludovic <ludo-ZPxbGqLxI0U@public.gmane.org>; Edwards, Nigel <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH] msleep() delays - replace with usleep_range() in TPM 1.2/2.0 generic drivers

On Mon, Jul 10, 2017 at 01:26:51PM +0000, Attak, Hamza wrote:
> msleep() delays - replace with usleep_range() in TPM 1.2/2.0 generic 
> drivers
> 
> Following the recent Nuvoton patch submitted by Mimi Zohar:
> https://sourceforge.net/p/tpmdd/mailman/message/35685260/

1. Please do not your work on a patch that was never applied.
   This one was https://patchwork.kernel.org/patch/9617835/
2. Please break your lines properly in the commit message 3. Please use commit ID in the mainline instead of URL.

Have you run scripts/checkpatch.pl?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
