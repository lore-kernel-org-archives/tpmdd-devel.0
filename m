From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] tpm: Get rid of devname
Date: Fri, 12 Feb 2016 18:13:23 -0700
Message-ID: <20160213011323.GB2547@obsidianresearch.com>
References: <1455321871-28296-4-git-send-email-jgunthorpe@obsidianresearch.com>
	<201602130853.47ON3KAx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201602130853.47ON3KAx%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 13, 2016 at 09:01:06AM +0800, kbuild test robot wrote:

> url:    https://github.com/0day-ci/linux/commits/Jason-Gunthorpe/tpm-Hold-the-kref-during-tpm_chip_find_get/20160213-080824
> config: xtensa-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
> 
> All warnings (new ones prefixed by >>):
>
>    drivers/char/tpm/tpm-chip.c: In function 'tpm1_chip_register':
> >> drivers/char/tpm/tpm-chip.c:193:19: warning: passing argument 1 of 'tpm_bios_log_setup' discards 'const' qualifier from pointer target type
>      chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
>                       ^
>    In file included from drivers/char/tpm/tpm-chip.c:30:0:
>    drivers/char/tpm/tpm_eventlog.h:83:31: note: expected 'char *' but argument is of type 'const char *'
>     static inline struct dentry **tpm_bios_log_setup(char *name)

Got it, thanks, didn't notice that kconfig variation.

Jason

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
