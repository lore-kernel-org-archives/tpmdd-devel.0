From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: Re: in-kernel user of ecdsa
Date: Mon, 26 Mar 2018 17:59:09 +0300
Message-ID: <4ce3391f-aa02-a157-bce1-754a6a87c8ed@microchip.com>
References: <0f698592-8ade-14d4-7891-1c35501c6285@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <0f698592-8ade-14d4-7891-1c35501c6285-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "bluez mailin list
 (linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Linux Crypto Mailing List <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



On 03/12/2018 07:07 PM, Tudor Ambarus wrote:

> Would you consider using ECDSA in the kernel module signing facility?

Any feedback is good. I can invest some time to make this happen, if
needed.

> When compared with RSA, ECDSA has shorter keys, the key generation
> process is faster, the sign operation is faster, but the verify
> operation is slower than with RSA.
> 
> Smaller key sizes imply reduced memory footprint and bandwidth that are
> especially attractive for memory constrained devices. I'm working with
> such a device, capable of generating ecc keys, secure key storage and
> ecdsa/ecdh crypto acceleration. I'm trying to find an in-kernel user of
> ecdsa.
> 
> 
> ECDSA and RSA comparison
> ------------------------
> -> ECDSA requires a much smaller key length in order to provide the same
> security strength as RSA [1]:
> 
> Security Strength    RSA (bits)        ECDSA (bits)
> 112                   2048             224 - 255
> 128                   3072             256 - 383
> 192                   7680             384 - 511
> 256                  15360             512+
> 
> 7680 and 15360  keys are not included in the NIST standards for
> interoperability and efficiency reasons, the keys are just too big.
> 
> -> key generation: ECC key generation is faster than IFC (Integer -
> Factorization Cryptography). RSA private key is based on large prime
> numbers, while for ECDSA any positive integer less than n is a valid
> private key.
> 
> -> ECDSA sign operations are faster than RSA, but verify operations are
> slower. Here's an openssl speed test that I've run on my computer:
> 
>                    sign    verify    sign/s verify/s
> rsa 2048 bits 0.000604s 0.000018s   1656.3  56813.7
> rsa 4096 bits 0.004027s 0.000062s    248.3  16052.5
> 
>                               sign    verify    sign/s verify/s
> 256 bit ecdsa (nistp256)   0.0000s   0.0001s  28986.4  13516.3
> 384 bit ecdsa (nistp384)   0.0002s   0.0008s   5541.0   1322.2
> 521 bit ecdsa (nistp521)   0.0003s   0.0006s   3104.2   1756.2
> 
> Best,
> ta
> 
> [1] NIST SP 800-57 Pt. 1 Rev. 4, Recommendation for key management
> -- 
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
