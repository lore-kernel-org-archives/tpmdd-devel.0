From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: constify transmit data pointers
Date: Sat, 9 Sep 2017 00:46:34 +0300
Message-ID: <20170908214634.2kglubmagnblmrmy@linux.intel.com>
References: <20170907133130.2463746-1-arnd@arndb.de>
 <20170907162403.4o3li6k74livw2bk@linux.intel.com>
 <CAK8P3a2nHEU7y98+jt+nSYfmRA-ju6SZhEJqTXqS_StU1d5p-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2nHEU7y98+jt+nSYfmRA-ju6SZhEJqTXqS_StU1d5p-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Colin Ian King <colin.king@canonical.com>, tpmdd-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 08, 2017 at 10:58:55PM +0200, Arnd Bergmann wrote:
> On Thu, Sep 7, 2017 at 6:24 PM, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> > On Thu, Sep 07, 2017 at 03:30:45PM +0200, Arnd Bergmann wrote:
> >>
> >
> > Thank you Arnd. Do you mind if squash this to Colin's commit and your
> > signed-off-by to that one?
> 
> Either way works, but if you merge the two commits into one, please
> clarify in the description who did what part, otherwise it might look like
> I just forwarded Jason's original patch to you.
> 
>       Arnd

I think it could be also a separate patch just to in order to make
that simple and also to retain information for git blame. Thanks.

/Jarkko
