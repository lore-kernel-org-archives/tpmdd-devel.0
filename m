From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm_tis_core: convert max timeouts from msec to jiffies
Date: Thu, 14 Jul 2016 21:06:38 -0600
Message-ID: <20160715030638.GA9347@obsidianresearch.com>
References: <1468542580-5296-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468542580-5296-1-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 05:29:40PM -0700, Andrey Pronin wrote:
> tpm_tis_core was missing conversion from msec when assigning
> max timeouts from constants.

Yep.

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Jason
