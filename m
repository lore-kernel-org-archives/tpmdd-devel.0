From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/5] Fix packed and aligned attribute warnings.
Date: Mon, 31 Jul 2017 13:27:47 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD0047420@AcuExch.aculab.com>
References: <20170729072433.13194-1-sz.lin@moxa.com>
 <20170729072433.13194-2-sz.lin@moxa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-2-sz.lin@moxa.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'SZ Lin' <sz.lin@moxa.com>, "ashleydlai@gmail.com" <ashleydlai@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "paulus@samba.org" <paulus@samba.org>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "tpmdd@selhorst.ne" <tpmdd@selhorst.ne>
List-Id: tpmdd-devel@lists.sourceforge.net

From: SZ Lin
> Sent: 29 July 2017 08:24
...
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
> index 91dfe766d080..9f708ca3dc84 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.h
> +++ b/drivers/char/tpm/tpm_ibmvtpm.h
> @@ -25,7 +25,7 @@ struct ibmvtpm_crq {
>  	__be16 len;
>  	__be32 data;
>  	__be64 reserved;
> -} __attribute__((packed, aligned(8)));
> +} __packed __aligned(8);

You can't need __packed and __aligned(8) on that structure.
There are no gaps and you are saying it is always aligned.

So just remove the pointless attributes.

	David
