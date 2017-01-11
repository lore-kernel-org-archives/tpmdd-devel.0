From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 07:39:53 -0800
Message-ID: <1484149193.2509.12.camel@HansenPartnership.com>
References: <kgoldman@us.ibm.com>
	<201701041612.v04GCfPK031525@wind.enjellic.com>
	<20170109231635.6wh25qoy7svcnys6@intel.com>
	<20170110200558.GA5102@obsidianresearch.com>
	<20170111113416.4h6ucm5y3hjjnfhv@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170111113416.4h6ucm5y3hjjnfhv-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-11 at 13:34 +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 10, 2017 at 01:05:58PM -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 10, 2017 at 01:16:35AM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Jan 04, 2017 at 10:12:41AM -0600, Dr. Greg Wettstein
> > > wrote:
> > > > The kernel needs a resource manager.  Everyone needs to think 
> > > > VERY hard and VERY, VERY carefully about what gets put into the
> > > > kernel.  In making a decision, put the ABSOLUTE smallest amount 
> > > > of code into the kernel which allows various 'TPM2 
> > > > personalities' to be implemented in userspace and functionally 
> > > > verified and protected by the physical instance.  The emergence 
> > > > of commodity TEE's (SGX, et.al) should be in the back of
> > > > everyone's mind as a factor in the roadmap.
> > > 
> > > Here's my cuts for the kernel:
> > > 
> > > - Kernel virtualizes handle areas. It's mechanical.
> > > - Kernel does not virtualize bodies. It's not mechanical.
> > > - At least the first version of the RM will not do other than
> > > session
> > >   isolation for sessions.
> > > 
> > > This keeps the core for RM inside the kernel small and tight.
> > 
> > I think this makes sense.
> > 
> > In addition the kernel should only permit RM operations that are 
> > known to be 100% correct with the RM.
> > 
> > I think you should stick with your original design basic design,
> > except instead of using an ioctl to switch modes, use an ioctl to
> > execute the operation:
> > 
> > struct tpm_ioctl_operation {
> >    u16 mode;  // == TPM1_RAW,TPM2_RAW,TPM1_RM,TPM2_RM
> >    u16 locality;
> >    u32 txlen;
> >    u32 rxlen;
> >    const void *txbuf;
> >    void *rxbuf;
> > };
> > 
> > The userspace broker would be expected to use a mixture of RM and 
> > RAW operations.
> > 
> > Let's deal with the idea of another cdev some other day when 
> > someone can figure out a comprehensive way to do that securely for
> > unpriv..
> 
> James, what do you think about this proposal?

I don't think it's a good idea for the reasons stated before:

RAW access means the ability to DoS the TPM simply by exhausting
handles.  Therefore, I think most applications only get RM access.  If
you adopt this proposal, then, if you're only opening a single fd, we
can't go by the unix permissions (even the RM only applications need to
open it), so we'd need some permissions infrastructure within the
kernel to reject RAW access from RM only users.  That's why having
multiple devices is much better because we can use the usual UNIX
mechanism to separate access from raw and rm.  I'm less sure about
localities, but there may be the same issue at some point (not all
applications get access to all localities).  It would be good to get
the localities use case sorted out before adding it to an ioctl based
interfaces.

James



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
