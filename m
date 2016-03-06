From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: ioctl API for vTPM driver
Date: Sun, 6 Mar 2016 14:11:03 +0200
Message-ID: <20160306121103.GA23480@intel.com>
References: <20160306120537.GA22702@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160306120537.GA22702-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 06, 2016 at 02:05:37PM +0200, Jarkko Sakkinen wrote:
> Hi
> 
> Some follow-up question that have popped up while I've started to
> write a test program for this feature mainly about ioctl API.  It's
> better to be extremly cautious here because we will be stuck with this
> ioctl forever.
> 
> 1. Why the ioctl name is VTPM_NEW_DEV but the struct name is
>    vtpm_new_pair? It would be better if they both were either
>    VTPM_NEW_DEV and vtpm_new_dev or alternatively VTPM_NEW_PAIR
>    and vtpm_new_pair.
> 2. Is 'pair' or 'tuple' a better term?
> 3. Where is the documentation for the ioctl? I don't think I can
>    merge this to my next branch before it exists.
> 4. I have forgotten why the major and minor numbers were returned.
>    My guess is that they were returned so that a container could
>    replicate the device? This is one reason why documentation is
>    mandatory.

5. Is there any particular reason why 'tpm_dev_num' couldn't simply be
   'dev_num'?

/Jarkko

------------------------------------------------------------------------------
