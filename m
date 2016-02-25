From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/12] tpm/st33zp24: Few code style and
 sanity fixes + acpi device probing support
Date: Thu, 25 Feb 2016 08:48:42 +0100
Message-ID: <56CEB1DA.4020709@gmail.com>
References: <1455376535-9549-1-git-send-email-christophe-h.ricard@st.com>
	<20160222235639.GA7721@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222235639.GA7721-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

I have checked your tree and sent a v3 fixing patch 10 and 12.

Best Regards
Christophe

On 23/02/2016 00:56, Jarkko Sakkinen wrote:
> On Sat, Feb 13, 2016 at 04:15:23PM +0100, Christophe Ricard wrote:
>> Hi Peter, Jarko,
>>
>> Please find in the following serie:
>> - a set of code style or sanity cleanup
>> - acpi device probing support for i2c and spi phys.
>>
>> In v2, i have:
>> - Added Jarkko review
>> - Fixed a warning on patch 12
>>
>> This serie applies on top of jarkko tree:
>> b64f343cb02b2a2a009b3805a8331425dd4a8611 tpm: fix rollback/cleanup before tpm_chip_register()
> I've now applied the patches to my master branch:
>
> * All of them have my Reviewed-by. For one patch I had to fix one style
>    error (one line was of over 80 characters).
> * Two of the patches have my Tested-by.
>
> Now I'm trying to get a Minnowboard so that I could test ACPI probing
> for I2C/SPI device. If that would work, then this seres would be ready
> for a pull request.
>
> Can you check quickly check the applied patches to make sure that I
> didn't mess anything up? And perhaps compile my master and see if
> things work at run-time as well?
>
>> Best Regards
>> Christophe
> /Jarkko
>
>> Christophe Ricard (12):
>>    tpm/st33zp24/spi: Remove nbr_dummy_bytes variable usage
>>    tpm/st33zp24/spi: Use functions name with st33zp24_spi_ prefix
>>    tpm/st33zp24/spi: Remove useless use of memcpy.
>>    tpm/st33zp24/spi: Remove field spi_xfer from st33zp24_spi_phy
>>      structure
>>    tpm/st33zp24: Remove unneeded CONFIG_OF switches
>>    tpm/st33zp24: Auto-select core module
>>    tpm/st33zp24/spi: Improve st33zp24_spi_evaluate_latency
>>    tpm/st33zp24: Extend Copyright headers
>>    tpm/st33zp24: Add support for acpi probing for i2c device.
>>    tpm: st33zp24: Add support for acpi probing for spi device.
>>    tpm/st33zp24/i2c: Change xxx_request_resources header
>>    tpm/st33zp24/spi: Change xxx_request_resources header
>>
>>   drivers/char/tpm/st33zp24/Kconfig      |  11 +-
>>   drivers/char/tpm/st33zp24/i2c.c        |  76 ++++++++++---
>>   drivers/char/tpm/st33zp24/spi.c        | 190 ++++++++++++++++++++-------------
>>   drivers/char/tpm/st33zp24/st33zp24.c   |   2 +-
>>   drivers/char/tpm/st33zp24/st33zp24.h   |   2 +-
>>   include/linux/platform_data/st33zp24.h |   2 +-
>>   6 files changed, 182 insertions(+), 101 deletions(-)
>>
>> -- 
>> 2.5.0
>>


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
