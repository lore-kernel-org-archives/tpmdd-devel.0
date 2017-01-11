From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 12:18:09 -0700
Message-ID: <20170111191809.GA28593@obsidianresearch.com>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
 <20170109231635.6wh25qoy7svcnys6@intel.com>
 <20170110200558.GA5102@obsidianresearch.com>
 <ee6c1e48-e21f-d05e-0939-473001224aba@sit.fraunhofer.de>
 <20170111180328.GB22783@obsidianresearch.com>
 <7a61bdf9-da82-c772-7e73-d4a4ffc25559@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7a61bdf9-da82-c772-7e73-d4a4ffc25559@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Andreas Fuchs <andreas.fuchs@sit.fraunhofer.de>, Ken Goldman <kgoldman@us.ibm.com>, greg@enjellic.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 11, 2017 at 01:27:30PM -0500, Stefan Berger wrote:
> On 01/11/2017 01:03 PM, Jason Gunthorpe wrote:
> >On Wed, Jan 11, 2017 at 11:00:43AM +0100, Andreas Fuchs wrote:
> >
> >>could we please get an ioctl, that switches the "mode" of the fd entirely.
> >>I'd like to see the write()/read() support still intact.
> >>All my current code uses main-loop based poll on the fd and I don't want
> >>to be force to start using threads...
> >We currently do not support poll in the kernel for /dev/tpmX.
> >
> >ie we do not supply a poll method for 'struct file_operations'.
> >
> >Even worse, the current implementation blocks returning from write()
> >until the TPM has completed its work, so it doesn't even make sense to
> >combine it with poll.
> 
> Newer applications could issue an ioctl() after the open() to unblock the
> write().

The ioctl api I outlined could support poll by having userspace set
the rxbuf = NULL.

The kernel would then launch the tx async and provide poll support to
allow read() to return the result once the tpm has finished.

This can be added as a new capability down the road..

Jason
