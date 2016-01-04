From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Mon, 4 Jan 2016 20:19:15 +0200
Message-ID: <20160104181915.GA15908@intel.com>
References: <20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org> <20151224114241.GA5119@intel.com>
	<n5h1rj$nkb$1@ger.gmane.org>
	<20160102203957.GA19490@obsidianresearch.com>
	<20160103135346.GA4047@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA5877E95@EXCH2010B.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA5877E95-wI35/lLZEdRyXeJKmmMAp2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 04, 2016 at 04:22:25PM +0000, Fuchs, Andreas wrote:
> > On Sat, Jan 02, 2016 at 01:39:57PM -0700, Jason Gunthorpe wrote:
> > > Ie the first step would be to create a new /dev/ node for the
> > > 'virtualized' tpm (vs the raw tpm we have now). We'd want to have some
> > > idea exactly what that is and exactly what the UAPI looks like, and
> > > make decsisions like, should there be one per tpm or one for all tpms?
> > 
> > Or you can get a new context when you open tpm device. There are
> > multiple options.
> 
> I guess there are ways to add stuff.
> 
> I'd like to get a list of people interested to work on some conceptual stuff
> first though.

I don't care in what process the patches are implemented. I can review
and test patches once there is something real to be evaluated.

> Some concrete questions that originate from my personal unfamiliarity with
> kernel coding that would influence my getting started concepting this thing:
> 
> - fd-duplication (dup(), fork(), ...): How to handle objects in this case ? It is
> possible to duplicate DH_HANDLES, but not SESSION_HANDLES.

What you are saying does not match the semantics of these system calls.
They do not duplicate data. Nothing needs to be done.

> It would be easiest to disallow dup() and fork(), similar to CLOEXEC but rather
> "CLOFORK". Is this possible ? What are alternatives ?
> 
> - Similarly, can/shall we allow fd-passing ? In context of the previous question,
> is it possible to force closing of fd in the original process when passing the fd ?
> What alternatives would there be ?
> 
> - What would be preferred, a layered approach vs a hook-table based approach ?
> What's generally used in kernel modules ?

This discussion about fd's is way out of context.

> Thanks for all inputs,
> Andreas

/Jarkko

------------------------------------------------------------------------------
