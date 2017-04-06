From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/4] Improve handling of TPM2 event logs
Date: Thu, 6 Apr 2017 09:35:34 +0300
Message-ID: <20170406063534.nw33ck7gek7g4vur@intel.com>
References: <20170329074330.b2rbsbt2zc7o22q7@petr-dev3.eng.vmware.com>
	<20170405114650.c2kkkz2th2emalcc@intel.com>
	<58E553A9.8010804@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58E553A9.8010804-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 05, 2017 at 01:29:29PM -0700, Petr Vandrovec wrote:
> Jarkko Sakkinen wrote:
> > On Wed, Mar 29, 2017 at 12:43:30AM -0700, Petr Vandrovec wrote:
> > > From: Petr Vandrovec<petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > 
> > > When TPM2 log has entries with more than 3 digests, or with digests
> > > not listed in the log header, log gets misparsed, eventually
> > > leading to kernel complaint that code tried to vmalloc 512MB of
> > > memory (I have no idea what would happen on bigger system).
> > 
> > It would be easier to follow this if you would give a concrete
> > example of such situation. Since you are contributing this, you
> > must must have bumped into this, haven't you?
> 
> Yes.  Our firmware reports TPM2 log with 4 digests (SHA1, SHA256, SHA384,
> SHA512).  Current code in kernel skips over first 3 digests only, trying to
> parse 4th digest as event length, coming to conclusion that entry is hundred
> of megabytes or few gigabytes long, and then failing to vmalloc() that
> amount of memory.
> 
> You can find parsed textual log at
> https://drive.google.com/open?id=0B7WL11GSMhrQRDBLWjc3bEZQTEk (192KB), and
> binary log at https://drive.google.com/open?id=0B7WL11GSMhrQQ1RCMmRmM2paR3c
> (48KB).
> 
> I hit situation with malformed event log on my Dell laptop - after TPM
> firmware got updated from 1.2 to 2.0, chip & everything is reported as TPM2,
> except that log stays in TPM1.2 format.

Great thank you. I think I'll merge this already to my master branch
(not yet the whole series). Thanks a lot for spotting and fixing this
regression.

/Jarkko 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
