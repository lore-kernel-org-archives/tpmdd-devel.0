From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/1] tpm_tis: convert to using
	locality callbacks
Date: Sun, 26 Mar 2017 18:40:27 -0400 (EDT)
Message-ID: <1536920674.6131725.1490568027655.JavaMail.zimbra@redhat.com>
References: <20170325200521.19224-1-jsnitsel@redhat.com>
	<20170325200521.19224-2-jsnitsel@redhat.com>
	<20170326203628.GA3113@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170326203628.GA3113-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



----- Original Message -----
> From: "Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> To: "Jerry Snitselaar" <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Peter Huewe" <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, "Jarkko
> Sakkinen" <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Marcel Selhorst" <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
> Sent: Sunday, March 26, 2017 1:36:28 PM
> Subject: Re: [RFC PATCH 1/1] tpm_tis: convert to using locality callbacks
> 
> On Sat, Mar 25, 2017 at 01:05:21PM -0700, Jerry Snitselaar wrote:
> 
> > @@ -672,7 +658,7 @@ void tpm_tis_remove(struct tpm_chip *chip)
> >  		interrupt = 0;
> >  
> >  	tpm_tis_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
> > -	release_locality(chip, priv->locality, 1);
> > +	release_locality(chip, priv->locality);
> 
> Why is this done during remove? The tpm core should now keep things so
> that there is not a requested locality except during command so execution
> we should not get here with a requested locality..
> 
> Jason
> 

You're right, this call should be dropped. With release_locality always releasing
now it shouldn't have a locality when going into remove. I'll drop this in v2.

Thanks,
Jerry

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
