From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] add irq validity check in
	tpm_i2c_nuvoton driver
Date: Wed, 29 Jun 2016 12:20:47 -0600
Message-ID: <20160629182047.GA17031@obsidianresearch.com>
References: <1467194329-5543-1-git-send-email-andrew.zamansky@nuvoton.com>
	<1467194329-5543-3-git-send-email-andrew.zamansky@nuvoton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467194329-5543-3-git-send-email-andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 29, 2016 at 12:58:49PM +0300, andrew zamansky wrote:
> if irq==0 (actualy invalid value) then error is printed to dmesg after
> trying to register to 0 interrupt 

Missing Signed-off-by line.

And this patch should have:

Fixes: 570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")

There is also no need to re-sent the patch that is being fixed.

> -	chip->flags |= TPM_CHIP_FLAG_IRQ;
> +	if(chip->flags)
> +		chip->flags |= TPM_CHIP_FLAG_IRQ;
> +

Don't forget to run checkpatch

Jason

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
