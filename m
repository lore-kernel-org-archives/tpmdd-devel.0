From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0111/1285] Replace numeric parameter like 0444 with macro
Date: Mon, 8 Aug 2016 14:16:07 +0300
Message-ID: <20160808111607.GA19346@intel.com>
References: <20160802104129.21155-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160802104129.21155-1-baolex.ni@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baole Ni <baolex.ni@intel.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, hpa@zytor.com, x86@kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, jslaby@suse.cz, peter@korsgaard.com, lee.jones@linaro.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 02, 2016 at 06:41:29PM +0800, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>

I choose to ignore this and other similar patches you have submitted
for the TPM driver subsystem.

/Jarkko
