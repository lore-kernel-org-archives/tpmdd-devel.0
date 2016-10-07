From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Fri, 7 Oct 2016 13:17:24 -0600
Message-ID: <20161007191724.GA28795@obsidianresearch.com>
References: <20161004164738.GA17149@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
 <20161004231057.GA20062@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
 <20161005171132.GE18636@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F54E9@hasmsx108.ger.corp.intel.com>
 <20161005211656.GA20920@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F561B@hasmsx108.ger.corp.intel.com>
 <20161006020748.GA17479@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F625A@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F625A@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 07, 2016 at 02:24:59PM +0000, Winkler, Tomas wrote:

> So here I'm to say I'm sorry for misleading this, after all the
> doubts I got back to debugging and traces.  One thing for a reason
> moving the device_del, had really made the problem go away, but the
> real problem was unbalance runtime_pm PUT/GET from the tpm_crb probe
> function.

Oh this is very good news, I'm glad this was resolved in crb!

Presumably the unbalanced put made the ref count go negative and the
balanced get caused it to go to zero, so pm locking was basically totally
broken? That would explain how an idle callback could run
concurrently with transmit_cmd.

Though a bit of a mystery why device_del had any impact? I'm still
very unclear exactly how the child device effects the parent - and
that seems like pretty important information going forward..

Thanks,
Jason
