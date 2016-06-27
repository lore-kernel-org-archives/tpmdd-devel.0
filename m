From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v8 1/5] tpm_tis: Improve reporting of IO
	errors
Date: Mon, 27 Jun 2016 11:55:35 -0600
Message-ID: <20160627175535.GB23540@obsidianresearch.com>
References: <1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
	<1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
	<1466557831-113440-2-git-send-email-eswierk@skyportsystems.com>
	<20160624182515.GC14506@obsidianresearch.com>
	<20160624202131.GB8399@intel.com>
	<20160624202615.GA2968@obsidianresearch.com>
	<20160625152430.GA14567@intel.com>
	<20160625154745.GA24538@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160625154745.GA24538-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jun 25, 2016 at 06:47:45PM +0300, Jarkko Sakkinen wrote:

> My repositories are ready for next pull request. The master has been
> rebased to James' tree and merged to next.

This seems fine..

Generally you shouldn't rebase to create pull requests, but this
seemed needed..

Organize your git tree so that it is always pullable and just use
merges/resets/etc in the -next branch

There is no reason to hold off on more stuff for 4.8, if another batch
is ready before the merge window then send it, James already took the
stuff you sent.

Jason

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
