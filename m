From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Fri, 25 Aug 2017 20:35:02 +0300
Message-ID: <20170825173502.q5oc3uovpvzi65dm@linux.intel.com>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
 <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
 <20170824122630.75sxjmkj5f7p7tv5@linux.intel.com>
 <7478e964-6553-9d1e-3d8f-83b044a9a562@codeaurora.org>
 <20170825162139.s5oasztecntzg223@linux.intel.com>
 <20170825165309.GB5254@obsidianresearch.com>
 <b1179dde-46af-7172-3f84-e8cabffa05d5@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b1179dde-46af-7172-3f84-e8cabffa05d5@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiandi An <anjiandi@codeaurora.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, peterhuewe@gmx.de, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 25, 2017 at 12:28:21PM -0500, Jiandi An wrote:
> 
> 
> On 08/25/2017 11:53 AM, Jason Gunthorpe wrote:
> > On Fri, Aug 25, 2017 at 07:21:39PM +0300, Jarkko Sakkinen wrote:
> > > As I said before it would make much more sense to make code always deal
> > > with sm and remove flags completely. That would help maintaining code
> > > easier as new logic for TZ is introduced.
> > 
> > Yes please
> > 
> > Jason
> > 
> Okay, I'll work on moving sm to priv and getting rid of flags from
> priv.  Will submit a new patch with appropriate patch name and not
> a v2 of this patch since the scope of changes have changed.
> 
> Thanks for your comments and feedback.

Great

/Jarkko
