From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 1/2] Documentation: tpm: add the IBM
 Virtual TPM device tree binding documentation
Date: Mon, 17 Oct 2016 07:38:58 +0530
Message-ID: <580432BA.5020300@linux.vnet.ibm.com>
References: <1475051441-23008-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160929110413.GA14359@intel.com>
	<57F55F28.1090005@linux.vnet.ibm.com>
	<20161008210112.GA22112@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161008210112.GA22112@rob-hp-laptop>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cclaudio-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 10/09/2016 02:31 AM, Rob Herring wrote:
> On Thu, Oct 06, 2016 at 01:44:32AM +0530, Nayna wrote:
>>
>>
>> On 09/29/2016 04:34 PM, Jarkko Sakkinen wrote:
>>> On Wed, Sep 28, 2016 at 04:30:40AM -0400, Nayna Jain wrote:
>>>> Virtual TPM, which is being used on IBM POWER7+ and POWER8 systems running
>>>> POWERVM, is currently supported by tpm device driver but lacks the
>>>> documentation. This patch adds the missing documentation for the existing
>>>> support.
>>>>
>>>> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> ---
>>>> Changelog v2:
>>>>
>>>> - New Patch
>>>>
>>>>   .../devicetree/bindings/security/tpm/ibmvtpm.txt   | 41 ++++++++++++++++++++++
>>>>   1 file changed, 41 insertions(+)
>>>>   create mode 100644 Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
>>>> new file mode 100644
>>>> index 0000000..d89f999
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
>>>> @@ -0,0 +1,41 @@
>>>> +* Device Tree Bindings for IBM Virtual Trusted Platform Module(vtpm)
>>>> +
>>>> +Required properties:
>>>> +
>>>> +- compatible            : property name that conveys the platform architecture
>>>> +                          identifiers, as 'IBM,vtpm'
>>>> +- device_type           : specifies type of virtual device
>>>
>>> A generic device tree question. What is the difference between
>>> these fields? Why the I2C one does have 'device_type'?
>>
>> Please find the details as below:
>>
>> compatible - Standard property name as per IEEE 1275, specifying the
>> interface compatible with this device. This property is consumed by linux
>> kernel for selection of device driver.
>>
>> device_type - Standard property name as per IEEE 1275, specifying the device
>> type. This property MAY be used by linux kernel for device driver selection.
>> It is used in the case of IBM virtual TPM driver.
>
> AIUI, this should be a standard value such as serial, pci, etc. I don't
> think your use here is correct, but I could be wrong. I'm not certain
> what you do with devices that don't have a standard type.

Actually, the vtpm node is a unique device and did not have a standard 
type that could be used.  That is why the definition in the PAPR gave it 
the a new value.  The intention was to provide a reasonable type value. 
  The "IBM," portion of the property value is intended to identify it as 
a specific IBM implementation.

Thanks & Regards,
    - Nayna

>
>>
>> /**
>>   * vio_register_device_node: - Register a new vio device.
>>   * @of_node:    The OF node for this device.
>>   *
>>   * Creates and initializes a vio_dev structure from the data in
>>   * of_node and adds it to the list of virtual devices.
>>   * Returns a pointer to the created vio_dev or NULL if node has
>>   * NULL device_type or compatible fields.
>>   */
>> struct vio_dev *vio_register_device_node(struct device_node *of_node)
>>
>> and vtpm device table being defined as below:
>>
>> static struct vio_device_id tpm_ibmvtpm_device_table[] = {
>>          { "IBM,vtpm", "IBM,vtpm"}, ----------------------------------->
>> type,compat
>>          { "", "" }
>> };
>>
>> So, vio (virtual) devices uses both device_type and compatible property for
>> device registration and driver selection.
>> In case of physical TPM, it is only compatible property being used for
>> device driver selection
>>
>> Also, please note that device_type property is now deprecated in latest
>> Device Tree specs.
>
> Deprecated for Flattened DT only. OpenFirmware implementations
> can/should still use this.
>
> Rob
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
