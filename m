From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 10:37:34 -0600
Message-ID: <20161005163734.GD18636@obsidianresearch.com>
References: <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
 <20161004231057.GA20062@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
 <20161005151526.GA9847@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161005151526.GA9847@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 05, 2016 at 06:15:26PM +0300, Jarkko Sakkinen wrote:

> The important thing is to notice that runtime PM requires the device
> to be "alive" and in the device hierarchy. It's a constraint...

There are two devices.

The chip->dev and the chip->dev.parent (aka the acpi_device)

Runtime PM is *only* attached to the chip->dev.parent - it does not
interact in any significant way with the chip->dev.

device_del is on the chip->dev. The acpi_device remains intact, and
fully functional.

This is why the whole patch is so confusing to me.

Jason
