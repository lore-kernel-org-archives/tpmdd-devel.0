From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 13:36:58 +0200
Message-ID: <20170111113658.u5tmmjbuqrxfgpol@intel.com>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
 <20170109231635.6wh25qoy7svcnys6@intel.com>
 <o53clt$uo9$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <o53clt$uo9$1@blaine.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 10, 2017 at 02:29:08PM -0500, Ken Goldman wrote:
> On 1/9/2017 6:16 PM, Jarkko Sakkinen wrote:
> > 
> > Here's my cuts for the kernel:
> > 
> > - Kernel virtualizes handle areas. It's mechanical.
> > - Kernel does not virtualize bodies. It's not mechanical.
> > - At least the first version of the RM will not do other than session
> >   isolation for sessions.
> 
> Is it correct that "bodies" are the parameter area of the commands and
> responses?
> 
> if so, eventually something should virtualize getcapability.  It may be
> safer in user space, but it can mask RM issues.

body == command / response - (header + handle area)

/Jarkko
