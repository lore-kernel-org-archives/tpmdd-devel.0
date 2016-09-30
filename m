From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
 support
Date: Fri, 30 Sep 2016 22:27:59 +0300
Message-ID: <20160930192759.GF9595@intel.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830071032.GB6215@intel.com>
	<57C71A48.8020505@linux.vnet.ibm.com>
	<20160901134501.GA14627@intel.com>
	<20160901145250.GA19529@intel.com>
	<57EB8425.6000005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57EB8425.6000005-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 28, 2016 at 02:19:41PM +0530, Nayna wrote:
> 
> 
> On 09/01/2016 08:22 PM, Jarkko Sakkinen wrote:
> >On Thu, Sep 01, 2016 at 04:45:01PM +0300, Jarkko Sakkinen wrote:
> >>On Wed, Aug 31, 2016 at 11:26:24PM +0530, Nayna wrote:
> >>>Thanks Jarkko for the review. I will address all your comments in my next
> >>>version of patches.
> >>
> >>OK maybe the point I'm trying to make if you forget all the whining is
> >>that with this particular feature we have to be extremely careful
> >>because of the number of stakeholders that depend on it.
> >>
> >>This is not something I would put into 4.10 and no matter who is doing
> >>it, it might take a few more iterations to get right. So take your time.
> >>There's no rush (or more like there can't be rush).
> >
> >Sorry, a typo. I meant the 4.9 release :) 4.10 release is an open
> >question. This should be in production quality by 4.9-rc4/5 in order
> >to make that happen.
> >
> >The good timeline for topic branch would be end of Oct before LPC so
> >that I could carry a setup involving Minnowboard and a discrete TPM
> >module and demo this. I already have a topic branch called 'tabrm'
> >in place for the same conference.
> 
> Sure Jarkko. Thanks for this !! I have included the feedbacks and have
> posted V4 version of the patches just now.

This is still on my backlog but I'm still waiting to get some usable
hardware.

I really would think that clean up stuff should be digested first.
That I can test with TPM 1.2 hardware. If I create now a topic branch
with all of the eight commits it's just too much overhead to maintain.

If the topic branch would only have TPM 2.0 specific stuff, then it
wouldn't be such big of a deal.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
