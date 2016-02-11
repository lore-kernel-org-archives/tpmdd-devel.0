From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 08/12] tpm/st33zp24: Extend Copyright
	headers
Date: Thu, 11 Feb 2016 16:22:49 +0200
Message-ID: <20160211142249.GE4231@intel.com>
References: <1455010021-21927-1-git-send-email-christophe-h.ricard@st.com>
	<1455010021-21927-9-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455010021-21927-9-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 09, 2016 at 10:26:57AM +0100, Christophe Ricard wrote:
> Extend copyright header to 2016
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/st33zp24/i2c.c        | 2 +-
>  drivers/char/tpm/st33zp24/spi.c        | 2 +-
>  drivers/char/tpm/st33zp24/st33zp24.c   | 2 +-
>  drivers/char/tpm/st33zp24/st33zp24.h   | 2 +-
>  include/linux/platform_data/st33zp24.h | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
> index a05fbd8..a49b6f1 100644
> --- a/drivers/char/tpm/st33zp24/i2c.c
> +++ b/drivers/char/tpm/st33zp24/i2c.c
> @@ -1,6 +1,6 @@
>  /*
>   * STMicroelectronics TPM I2C Linux driver for TPM ST33ZP24
> - * Copyright (C) 2009 - 2015 STMicroelectronics
> + * Copyright (C) 2009 - 2016 STMicroelectronics
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index 7cabf1d..34cdee1 100644
> --- a/drivers/char/tpm/st33zp24/spi.c
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -1,6 +1,6 @@
>  /*
>   * STMicroelectronics TPM SPI Linux driver for TPM ST33ZP24
> - * Copyright (C) 2009 - 2015  STMicroelectronics
> + * Copyright (C) 2009 - 2016 STMicroelectronics
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index 8d62678..944d279 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -1,6 +1,6 @@
>  /*
>   * STMicroelectronics TPM Linux driver for TPM ST33ZP24
> - * Copyright (C) 2009 - 2015 STMicroelectronics
> + * Copyright (C) 2009 - 2016 STMicroelectronics
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.h b/drivers/char/tpm/st33zp24/st33zp24.h
> index c207ceb..bcbd5ff 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.h
> +++ b/drivers/char/tpm/st33zp24/st33zp24.h
> @@ -1,6 +1,6 @@
>  /*
>   * STMicroelectronics TPM Linux driver for TPM ST33ZP24
> - * Copyright (C) 2009 - 2015  STMicroelectronics
> + * Copyright (C) 2009 - 2016  STMicroelectronics
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> diff --git a/include/linux/platform_data/st33zp24.h b/include/linux/platform_data/st33zp24.h
> index 817dfdb..6f0fb6e 100644
> --- a/include/linux/platform_data/st33zp24.h
> +++ b/include/linux/platform_data/st33zp24.h
> @@ -1,6 +1,6 @@
>  /*
>   * STMicroelectronics TPM Linux driver for TPM 1.2 ST33ZP24
> - * Copyright (C) 2009 - 2015  STMicroelectronics
> + * Copyright (C) 2009 - 2016  STMicroelectronics
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
