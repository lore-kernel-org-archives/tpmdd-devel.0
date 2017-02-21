From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm: Apply an adapterlimit for
 retransmission.
Date: Tue, 21 Feb 2017 17:29:48 +0100
Message-ID: <20170221162948.GD25818@lunn.ch>
References: <20170221144500.502-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221144500.502-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, apronin@google.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 21, 2017 at 03:44:59PM +0100, Enric Balletbo i Serra wrote:
> From: Bryan Freed <bfreed@chromium.org>
> 
> When the I2C Infineon part is attached to an I2C adapter that imposes
> a size limitation, large requests will fail -EINVAL.
> Retry them with size backoff without re-issuing the 0x05 command
> as this appears to occasionally put the TPM in a bad state.

Hi Enric

Rather than trying small and smaller transfers, would it not be better
to get the i2c core to expose the quirk info about transfer limits?

   Andrew
