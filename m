From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v8 1/5] tpm_tis: Improve reporting of IO
	errors
Date: Sat, 25 Jun 2016 18:47:45 +0300
Message-ID: <20160625154745.GA24538@intel.com>
References: <1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
	<1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
	<1466557831-113440-2-git-send-email-eswierk@skyportsystems.com>
	<20160624182515.GC14506@obsidianresearch.com>
	<20160624202131.GB8399@intel.com>
	<20160624202615.GA2968@obsidianresearch.com>
	<20160625152430.GA14567@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160625152430.GA14567-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Jun 25, 2016 at 06:24:30PM +0300, Jarkko Sakkinen wrote:
> On Fri, Jun 24, 2016 at 02:26:15PM -0600, Jason Gunthorpe wrote:
> > On Fri, Jun 24, 2016 at 11:21:31PM +0300, Jarkko Sakkinen wrote:
> > > Hmm... Do you mean by 4 month old stuff the stuff that is in mainline
> > > and not in my master branch?
> > 
> > I mean the stuff that is in your branch but not in mainline.
> > 
> > $ git log --pretty=oneline jarkko/master ^v4.7-rc3 | wc -l
> > 73
> > 
> > > I'm not sure what happened with 4.7. I merged the changes for in about
> > > 4.6-rc5. There was one issue that I fixed that Stephen reported.
> > > 
> > > At the moment linux-next seems contain the stuff that I have in my
> > > next.
> > 
> > linux-next is just pulling directly from your tree, you still have to
> > ensure that James gets and processes your pull request during the
> > merge window. If he dropped a pull request you should follow up and
> > ask why, if you never sent one then ... oops :)
> 
> For 4.6 I used pull request with a signed tag and everything went quite
> well.
> 
> For 4.7 I did re-read the whole development process documentation but it
> only speaks about pull requests and does not clearly state what you just
> stated.
> 
> To summarize I screwed this one up but I guess the only big harm is that
> vTPM support will skip to 4.8. I guess not big harm done?
> 
> My master is now rebased and this is what I get:
> 
> $ git log --oneline security/next...master | wc -l
> 67
> 
> I don't think that is too bad.

My repositories are ready for next pull request. The master has been
rebased to James' tree and merged to next.

I won't add any new commits expect critical bug fixes for 4.8 release
content.

/Jarkko

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
