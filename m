From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 1/3] tpm_crb: expand struct
 crb_control_area to struct crb_regs
Date: Sun, 9 Oct 2016 21:26:50 -0600
Message-ID: <20161010032650.GA26695@obsidianresearch.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475972112-2819-2-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20161009014256.GA8210@obsidianresearch.com>
 <20161009093818.GG31891@intel.com>
 <20161009164905.GA12551@obsidianresearch.com>
 <20161009183232.GA27764@intel.com>
 <20161009183358.GB27764@intel.com>
 <20161009230737.GA23823@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F7497@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F7497@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 10, 2016 at 12:25:11AM +0000, Winkler, Tomas wrote:

> I addition I believe it should be always on offset FED4_0xxxh by the
> Spec, so all this arithmetic is a bit of overkill.

We don't have any hard coded addresses in the drivers - that seems
very inappropriate these days..

Is that address really not discoverable via ACPI somehow?

Jason
