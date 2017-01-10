From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: TPM 2.0 RM flushcontext returning bad address
Date: Tue, 10 Jan 2017 15:42:25 -0700
Message-ID: <20170110224225.GA5451@obsidianresearch.com>
References: <o53ei5$sc5$1@blaine.gmane.org>
	<20170110200803.GB5102@obsidianresearch.com>
	<o53ncb$e8q$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <o53ncb$e8q$1@blaine.gmane.org>
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

On Tue, Jan 10, 2017 at 05:31:45PM -0500, Ken Goldman wrote:
> On 1/10/2017 3:08 PM, Jason Gunthorpe wrote:
> >> 4 - Is a write() error desirable?  I think the application would prefer
> >> a TPM formatted response like TPM_RC_VALUE.
> >
>  >
> > IMHO, I prefer the write errno, but we need to clearly define what our
> > errnos means. Errnos used by RM should not overlap with errnos from
> > other parts of our kernel stack.
> >
> > This makes it clear the kernel is source of the error, not the physical TPM.
> 
> Except that the kernel is clearly not the source of the error.  The user 
> application tried to flush a handle and specified the wrong handle number.
> 
> "write error" sounds like a write error, but the TPMDD didn't actually
> write anything.

We are probably going to be going to ioctl, so it would be an ioctl
error.

> "bad address" sounds like the kernel tried to access a bad address.  But 
> it didn't access any address.

.. and we have to define what all the possible errnos mean. Defining
EBADF to mean 'RM found invalid handle in message' is probably sane.

> 2 - What's the TSS supposed to do with it?  I can return some generic 
> "problem in the TPM device driver".

Depends on the midlayer I suppose. If it supports string error
formatting it could decode EBADF to the string 'RM found invalid
handle in message' for instance.

Jason

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
