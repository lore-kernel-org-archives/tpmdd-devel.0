From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 2/3] TPM2.0: TPM Device Tree
 Documentation
Date: Fri, 12 Aug 2016 18:06:05 +0530
Message-ID: <57ADC2B5.3040903@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20160809221239.GB5535@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160809221239.GB5535-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

Thanks for review, My responses inline.

On 08/10/2016 03:42 AM, Jason Gunthorpe wrote:
> On Tue, Aug 09, 2016 at 03:34:54PM -0400, Nayna Jain wrote:
>> Added device tree binding documentation for I2C base TPM.
>
> You need to review
>
>   Documentation/devicetree/bindings/submitting-patches.txt
>
> And be sure to follow all the requirements, including CC'ing the
> right maintainers
Sure, will do. Can you tell me who all should I copy ?

>
> Also explain that this is a documenting a historical practice that IBM
> has used in systems  X Y Z.

Ok.

>
>> Changelog v2:
>>          * Added documentation in v2.
>
> Do not include these lines in commit messages, put them after the
> diff stat.

Actually I have not added Changelog during commit, I have put them in 
patch before posting. However, will add them after diff next time.
>
>> +This node describes a TPM device connected to Processor on i2c bus.
>> +
>> +Required properties:
>> +
>> +- compatible : 'manufacturer,model'
>> +- label : "tpm" indicates master TPM; "tpm-backup" indicates backup TPM.
>> +- linux,sml-base : base address of the Event Log. It is a physical address.
>> +		   sml stands for shared memory log.
>> +- linux,sml-size : size of the memory allocated for the Event Log.
>> +
>> +Optional properties:
>> +
>> +- status: indicates whether the device is enabled or disabled. "okay" for
>> +          enabled and "disabled" for disabled.
>> +
>> +Example
>> +-------
>> +
>> +tpm@57 {
>> +	reg = <0x57>;
>> +	label = "tpm";
>> +	compatible = "nuvoton,npct650", "nuvoton,npct601";
>> +	linux,sml-base = <0x7f 0xfd450000>;
>> +	linux,sml-size = <0x10000>;
>> +	status = "okay";
>
>> +	phandle = <0x10000017>;
>> +	linux,phandle = <0x10000017>;
>
>   What are these?

Sorry I didn't get your question here. I have written in the format as 
suggested for device-tree documentation and looking at other 
device-nodes documentation. And so this is an example entry as I saw in 
other docs.

>
> Jason
>


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
