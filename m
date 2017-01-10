From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 10 Jan 2017 13:05:58 -0700
Message-ID: <20170110200558.GA5102@obsidianresearch.com>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
 <20170109231635.6wh25qoy7svcnys6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170109231635.6wh25qoy7svcnys6@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: greg@enjellic.com, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Ken Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 10, 2017 at 01:16:35AM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 04, 2017 at 10:12:41AM -0600, Dr. Greg Wettstein wrote:
> > The kernel needs a resource manager.  Everyone needs to think VERY
> > hard and VERY, VERY carefully about what gets put into the kernel.  In
> > making a decision, put the ABSOLUTE smallest amount of code into the
> > kernel which allows various 'TPM2 personalities' to be implemented in
> > userspace and functionally verified and protected by the physical
> > instance.  The emergence of commodity TEE's (SGX, et.al) should be in
> > the back of everyone's mind as a factor in the roadmap.
> 
> Here's my cuts for the kernel:
> 
> - Kernel virtualizes handle areas. It's mechanical.
> - Kernel does not virtualize bodies. It's not mechanical.
> - At least the first version of the RM will not do other than session
>   isolation for sessions.
> 
> This keeps the core for RM inside the kernel small and tight.

I think this makes sense.

In addition the kernel should only permit RM operations that are known
to be 100% correct with the RM.

I think you should stick with your original design basic design,
except instead of using an ioctl to switch modes, use an ioctl to
execute the operation:

struct tpm_ioctl_operation {
   u16 mode;  // == TPM1_RAW,TPM2_RAW,TPM1_RM,TPM2_RM
   u16 locality;
   u32 txlen;
   u32 rxlen;
   const void *txbuf;
   void *rxbuf;
};

The userspace broker would be expected to use a mixture of RM and RAW
operations.

Let's deal with the idea of another cdev some other day when someone
can figure out a comprehensive way to do that securely for unpriv..

Jason
