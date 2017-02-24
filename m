From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH v2 6/7] tpm: expose spaces via a device
 link /dev/tpms<n>
Date: Fri, 24 Feb 2017 16:23:27 -0700
Message-ID: <20170224232327.GA9126@obsidianresearch.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
 <20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
 <20170223090917.jq7thil5ggjmagil@intel.com>
 <1487941328.2249.23.camel@HansenPartnership.com>
 <20170224173922.qwuhfxeitbyct52o@intel.com>
 <20170224181126.GC22491@obsidianresearch.com>
 <1487968155.2190.14.camel@HansenPartnership.com>
 <20170224205200.GA26547@obsidianresearch.com>
 <1487977260.2190.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487977260.2190.17.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open list <linux-kernel@vger.kernel.org>, dhowells@redhat.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 24, 2017 at 06:01:00PM -0500, James Bottomley wrote:

> Well, as a glib answer, I'd say the TPM is a device, so the thing which
> restricts device access to containers is the device cgroup ... that's
> what we should be plugging into.  I'd have to look, but I suspect the
> device cgroup basically operates on device node appearance, so it
> should "just work"(tm).  I can explore when I'm back home.

Seems reasonable..

It just seems confusing to call something a namespace that isn't also
a CLONE_NEW* option..

FWIW more background on the topic:

Stefan was concerned about information leakage via sysfs of TPM data,
eg that a container could still touch the host's TPM. I wonder if
device cgroup could be extended to block access to the sysfs
directories containing a disallowed 'dev' ?

I was also wondering about kernel use from within the container -
all kernel consumers are locked to physical tpm0.. But maybe the
kernel can consult the right device cgroup to find an allowed TPM?

Jason
