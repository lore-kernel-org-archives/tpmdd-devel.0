From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] Add "shutdown" to "struct class".
Date: Mon, 15 May 2017 09:51:10 -0600
Message-ID: <20170515155110.GC3433@obsidianresearch.com>
References: <20170512233203.23659-1-joshz@google.com>
 <5B8DA87D05A7694D9FA63FD143655C1B641D7A27@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B641D7A27@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Josh Zimmerman <joshz@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, May 13, 2017 at 12:43:11PM +0000, Winkler, Tomas wrote:
> > The TPM class has some common shutdown code that must be executed for
> > all drivers. This adds some needed functionality for that
> 
> The issue with this is, that on some platforms the only storage can
> be eMMC and TPM is using it,. It has to be ensured that the storage
> device won't go down before TPM2_shutdown is called.  And there is
> no direct device hierarchy to ensure an orderly shutdown.

Something will have to use the new device links stuff to define that
dependency, but that seems unrelated to this patch?

Can the kernel really shut down the eMMC while the hidden platform
stuff is still possibly using it? Goofy..

Jason
