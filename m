From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH v2 0/2] tpm: add driver for cr50 on SPI
Date: Wed, 27 Jul 2016 14:12:58 -0700
Message-ID: <20160727211258.GC119121@apronin>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <cover.1468985673.git.apronin@chromium.org>
 <trinity-26286f32-3045-4711-8972-ee0964b74003-1469466561717@3capp-gmx-bs15>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-26286f32-3045-4711-8972-ee0964b74003-1469466561717@3capp-gmx-bs15>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Peter,

> > This patchset adds support for H1 Secure Microcontroller running
> > Cr50 firmware. It implements several functions, including TPM-like
> > functionality, and communicates over SPI using the FIFO protocol
> > described in the PTP Spec, section 6.
> > H1 is a proprietary chip that the Chrome OS team is investigating
> > for inclusion in future Chromebooks.
> 
> so is this "broken" device already in the field? (i.e. can I buy it? how many of them)
> from the description it seems not. ("future chromebooks")

You're right the device is not in the field yet. I'm sending this driver
upstream before the hardware is publicly available, so people can start
using it when the devices are available. And I've gathered quite a lot
of useful feedback already.

> --> how likely is it that the firmware of that device will be fixed that it can work with the regular driver?
> 

It's hard to tell what will change in the future versions of firmware. I
expect that at least some specifics will stay.

> Although I really like to see driver upstreamed, I also want to avoid maintenance hell for obscure hardware :/
> 

I understand, but the idea was to support the hardware that is not
available yet, but will be in the future.

I'll be sending the new versions of the cr50 driver patches shortly.

Thanks,
Andrey
