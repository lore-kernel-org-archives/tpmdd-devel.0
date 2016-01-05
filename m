From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Tue, 05 Jan 2016 08:13:13 -0500
Message-ID: <1451999593.2772.165.camel@linux.vnet.ibm.com>
References: <20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>	<n5ed19$pqo$1@ger.gmane.org>
	<20151224114241.GA5119@intel.com> <n5h1rj$nkb$1@ger.gmane.org>
	<20160102203957.GA19490@obsidianresearch.com>
	<20160103135346.GA4047@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA5877E95@EXCH2010B.sit.fraunhofer.de>
	, <20160104181915.GA15908@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA58784A8@EXCH2010B.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA58784A8-wI35/lLZEdRyXeJKmmMAp2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ken-3MP/CPU4Muo+UXBhvPuGgqsjOiXwFzmk@public.gmane.org, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2016-01-05 at 09:43 +0000, Fuchs, Andreas wrote:
> > > I'd like to get a list of people interested to work on some conceptual stuff
> > > first though.
> > 
> > I don't care in what process the patches are implemented. I can review
> > and test patches once there is something real to be evaluated.
> 
> Understood, you and Mimi do not want to talk concept without code.
> However, I'd prefer to have some things steightened out conceptually, before
> running in wrong directions for weeks. Therefore, if anyone is willing to
> argue some design choices with me, I appreciate the help.

At this stage, the design discussion needs to be at a higher level as to
how the project will be broken up into smaller, more manageable chunks
(eg. patch sets) for review.  The design issues of the individual patch
sets will be reviewed/discussed as they're posted.

Mimi


------------------------------------------------------------------------------
