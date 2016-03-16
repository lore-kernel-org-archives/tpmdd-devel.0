From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix tpm_bios_log_setup stub prototype
Date: Wed, 16 Mar 2016 12:13:41 +0200
Message-ID: <20160316101341.GA4051@intel.com>
References: <1458116410-3208536-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458116410-3208536-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "Hon Ching (Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 16, 2016 at 09:19:48AM +0100, Arnd Bergmann wrote:
> A cleanup patch changed the prototype of the regular tpm_bios_log_setup
> function, but not that of the stub that is used when the TPM is disabled,
> causing a harmless build warning:
> 
> drivers/char/tpm/tpm-chip.c: In function 'tpm1_chip_register':
> drivers/char/tpm/tpm-chip.c:287:38: error: passing argument 1 of 'tpm_bios_log_setup' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
>   chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
> In file included from ../drivers/char/tpm/tpm-chip.c:30:0:
> ../drivers/char/tpm/tpm_eventlog.h:83:31: note: expected 'char *' but argument is of type 'const char *'
>  static inline struct dentry **tpm_bios_log_setup(char *name)
> 
> This changes the stub function to match the normal prototype,
> avoiding that warning.

Good catch. Thank you.

> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Fixes: aca8db8088c3 ("tpm: Get rid of devname")
> ---
>  drivers/char/tpm/tpm_eventlog.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> index cc9672f64e8f..8de62b09be51 100644
> --- a/drivers/char/tpm/tpm_eventlog.h
> +++ b/drivers/char/tpm/tpm_eventlog.h
> @@ -80,7 +80,7 @@ int read_log(struct tpm_bios_log *log);
>  extern struct dentry **tpm_bios_log_setup(const char *);
>  extern void tpm_bios_log_teardown(struct dentry **);
>  #else
> -static inline struct dentry **tpm_bios_log_setup(char *name)
> +static inline struct dentry **tpm_bios_log_setup(const char *name)
>  {
>  	return NULL;
>  }
> -- 
> 2.7.0

/Jarkko

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
