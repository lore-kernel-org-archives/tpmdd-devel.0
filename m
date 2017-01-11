From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 10:25:57 -0800
Message-ID: <1484159157.2509.23.camel@HansenPartnership.com>
References: <kgoldman@us.ibm.com>
         <201701041612.v04GCfPK031525@wind.enjellic.com>
         <20170109231635.6wh25qoy7svcnys6@intel.com>
         <20170110200558.GA5102@obsidianresearch.com>
         <20170111113416.4h6ucm5y3hjjnfhv@intel.com>
         <1484149193.2509.12.camel@HansenPartnership.com>
         <20170111175657.GA22783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170111175657.GA22783@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ken Goldman <kgoldman@us.ibm.com>, greg@enjellic.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-11 at 10:56 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2017 at 07:39:53AM -0800, James Bottomley wrote:
> 
> > RAW access means the ability to DoS the TPM simply by exhausting
> > handles.  Therefore, I think most applications only get RM access.
> 
> Re-read what Jarkko is proposing. He is not making a complete safe &
> secure RM in the kernel. He is making a tool to allow userspace and
> the kernel to share the TPM sanely.
> 
> It is not an access control tool, it is not a security tool, it is 
> not intended to support safe unpriv userspace access.
> 
> So there is no reason to have a different access control model in
> userspace, it is not a fundamentally different security environment
> from the existing raw device.
> 
> A future project to provide an unpriv safe cdev from the kernel is
> something different.

Right, but we're going around in circles.  I'm currently researching
what it would take to be daemonless, so an ioctl which requires an
access broker daemon would obviously be something I'd object to.

Basically, though, I think you can do both: we can add an ioctl and the
differing device hooks.  I just think for that case RAW vs RM would be
redundant.

James

