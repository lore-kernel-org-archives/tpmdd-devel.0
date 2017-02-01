From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Resource manager tabrm5 fails sessions
Date: Wed, 1 Feb 2017 10:10:47 +0200
Message-ID: <20170201081047.fpvj6ot3v2geyq74@intel.com>
References: <o6qtoh$9nn$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <o6qtoh$9nn$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 31, 2017 at 03:57:59PM -0500, Ken Goldman wrote:
> Should tabrm5 have the session swapping yet?  Is there a different head 
> I should be using?

No. You have to apply the patch manually. 

/Jarkko

> 
> ~~~~
> 
> I have the following test:
> 
>     create a primary storage key
>     create 2 signing keys under the storage key, each with a different 
> password
>     load all 2 keys
>     create an hmac session
>     sign with each key
> 
> ~~~~
> 
> When I run three of these processes, it passes.  Each test has 3 loaded 
> keys (all slots filled) and one session slot filled. This indicates that 
> transient object swapping is working.
> 
> When I start fourth process, it fails creating the session.  The error
> is:
> 
> rc 00000903
> TPM_RC_SESSION_MEMORY - out of memory for session contexts
> 
> This indicates that session swapping is not occurring.
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
