From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 12:04:28 -0700
Message-ID: <20170111190428.GA17873@obsidianresearch.com>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
 <20170109231635.6wh25qoy7svcnys6@intel.com>
 <20170110200558.GA5102@obsidianresearch.com>
 <20170111113416.4h6ucm5y3hjjnfhv@intel.com>
 <1484149193.2509.12.camel@HansenPartnership.com>
 <20170111175657.GA22783@obsidianresearch.com>
 <1484159157.2509.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484159157.2509.23.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ken Goldman <kgoldman@us.ibm.com>, greg@enjellic.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 11, 2017 at 10:25:57AM -0800, James Bottomley wrote:

> Right, but we're going around in circles.  I'm currently researching
> what it would take to be daemonless, so an ioctl which requires an
> access broker daemon would obviously be something I'd object to.

Well, when we figure out a security model that works for that and can
be implemented in the kernel then lets add the new cdev.

But that is *explicitly* not what Jarkko is doing, no reason to jump
the gun.

> Basically, though, I think you can do both: we can add an ioctl and the
> differing device hooks.  I just think for that case RAW vs RM would be
> redundant.

Right, some future new cdev would only support ioctl and only the RM
path, but for priv use having both concurrently available makes sense
as a userspace broker producing a full RM will need to using both paths.

Jason
