From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix tpm_transmit() parameters
Date: Thu, 7 Apr 2016 13:12:37 +0300
Message-ID: <20160407101237.GA7724@intel.com>
References: <1459866221-20052-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <C9F3B93A-7CEC-40DE-A189-F979BF936C4F@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C9F3B93A-7CEC-40DE-A189-F979BF936C4F@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Christophe Ricard <christophe-h.ricard@st.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 05, 2016 at 08:25:58AM -0700, Peter Huewe wrote:
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Thanks Peter. I'll include this to a patch set that I'm sending a bit
later that unifies the API to use one function everywhere. Now we have
both tpm_transmit() and tpm_transmit_cmd(), which does not make sense.

> -- 
> Sent from my mobile

/Jarkko
